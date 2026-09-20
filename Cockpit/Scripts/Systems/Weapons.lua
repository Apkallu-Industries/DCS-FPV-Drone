dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.common_script_path.."../../../Database/wsTypes.lua")

local Dev = GetSelf()
local update_rate = 0.02 -- 50Hz for immediate impact detection
make_default_activity(update_rate)

local sensor_data = get_base_data()
local fuse_armed = false
local time_airborne = 0.0
local warhead_master_arm = true
local detonated = false
local last_speed = 0.0

local WarheadStatus  = get_param_handle("WarheadStatus")
local DroneDestroyed = get_param_handle("DroneDestroyed")
local BatteryPercent = get_param_handle("BatteryPercent")
local BatteryVoltage = get_param_handle("BatteryVoltage")
local CellVoltage    = get_param_handle("CellVoltage")
local isArmed        = get_param_handle("isArmed")
local FlightMode     = get_param_handle("FlightMode")
local ScreenStatic   = get_param_handle("ScreenStatic")

function post_initialize()
	fuse_armed = false
	time_airborne = 0.0
	warhead_master_arm = true
	detonated = false
	last_speed = 0.0
	WarheadStatus:set(1)
	DroneDestroyed:set(0)
end

local function execute_detonation()
	if detonated then return end
	detonated = true

	-- 1. Detonate warhead forward into target
	Dev:launch_station(0)

	-- 2. Trigger complete physical & visual destruction of the airframe
	set_aircraft_draw_argument_value(308, 1.0) -- weapon consumed / detached
	set_aircraft_draw_argument_value(151, 1.0) -- MAIN fuselage catastrophic damage
	set_aircraft_draw_argument_value(149, 1.0) -- COCKPIT destroyed (kills pilot)
	set_aircraft_draw_argument_value(152, 1.0) -- Arm 1 broken
	set_aircraft_draw_argument_value(153, 1.0) -- Arm 2 broken
	set_aircraft_draw_argument_value(154, 1.0) -- Arm 3 broken
	set_aircraft_draw_argument_value(155, 1.0) -- Arm 4 broken
	set_aircraft_draw_argument_value(156, 1.0) -- Line WING L
	set_aircraft_draw_argument_value(157, 1.0) -- Line WING R
	set_aircraft_draw_argument_value(158, 1.0) -- Line STABIL L
	set_aircraft_draw_argument_value(159, 1.0) -- Line STABIL R

	-- 3. Cut all electrical power, motors, and flight avionics
	DroneDestroyed:set(1)
	BatteryPercent:set(0)
	BatteryVoltage:set(0)
	CellVoltage:set(0)
	isArmed:set(0)
	FlightMode:set(-1)
	WarheadStatus:set(0)

	-- 4. Instant FPV video feed cutout to static snow
	ScreenStatic:set(1)

	-- 5. Dispatch control kills and DCS pilot death/abandonment
	if dispatch_action then
		dispatch_action(0, 2001, 0.0) -- Pitch null
		dispatch_action(0, 2002, 0.0) -- Roll null
		dispatch_action(0, 2003, 0.0) -- Yaw null
		dispatch_action(0, 2004, 0.0) -- Throttle ZERO
		-- PlaneEject (83) forces DCS to register airframe loss / pilot ejection / crash
		dispatch_action(0, 83)
		dispatch_action(0, 83)
		dispatch_action(0, 83)
	end
end

function update() 
	if detonated then
		-- Keep static active
		ScreenStatic:set(1)
		return
	end

	if sensor_data then
		local alt = 0.0
		if sensor_data.getRadarAltitude then
			alt = sensor_data.getRadarAltitude() or 0.0
		elseif sensor_data.getBarometricAltitude then
			alt = sensor_data.getBarometricAltitude() or 0.0
		end

		local speed = 0.0
		if sensor_data.getSelfVelocity then
			local vx, vy, vz = sensor_data.getSelfVelocity()
			if vx and vy and vz then
				speed = math.sqrt(vx*vx + vy*vy + vz*vz)
			end
		elseif sensor_data.getTrueAirSpeed then
			speed = sensor_data.getTrueAirSpeed() or 0.0
		elseif sensor_data.getSelfAirspeed then
			speed = sensor_data.getSelfAirspeed() or 0.0
		end

		-- Airborne Detection & Fuse Arming
		if alt > 1.0 or speed > 2.5 then
			time_airborne = time_airborne + update_rate
			-- After 1.5 seconds airborne / in motion, warhead impact fuse is LIVE
			if time_airborne >= 1.5 then
				fuse_armed = true
			end
		else
			-- On the ground and stationary (< 0.8 m/s)
			if speed < 0.8 and alt < 0.5 then
				-- Safe mode engaged (perch / gentle landing)
				fuse_armed = false
				time_airborne = 0.0
			end
		end

		-- Multi-Vector Impact Detection (Against any target, vehicle, ground, or obstacle)
		if warhead_master_arm and fuse_armed then
			-- Vector 1: Sudden Deceleration Spike (Abrupt speed drop = impact with obstacle/armor)
			if last_speed > 3.0 and (last_speed - speed) > 2.0 then
				execute_detonation()
				return
			end

			-- Vector 2: Ground / Terrain Proximity Impact (> 3.0 m/s at < 0.60m)
			if alt > 0 and alt < 0.60 and speed > 3.0 then
				execute_detonation()
				return
			end

			-- Vector 3: Extreme G-Force / Acceleration shock (> 30G)
			if sensor_data.getSelfAcceleration then
				local ax, ay, az = sensor_data.getSelfAcceleration()
				if ax and ay and az then
					local g_sq = (ax*ax + ay*ay + az*az)
					if g_sq > 900.0 then -- ~30G
						execute_detonation()
						return
					end
				end
			end
		end

		last_speed = speed
	end
end

Dev:listen_command(Keys.WarheadArmToggle)
Dev:listen_command(Keys.DetonateWeapon)
Dev:listen_event("Crash")
Dev:listen_event("Kill")
Dev:listen_event("CrashPilot")

function SetCommand(command,value)
	if command == Keys.WarheadArmToggle then
		warhead_master_arm = not warhead_master_arm
		WarheadStatus:set(warhead_master_arm and 1 or 0)
	elseif command == Keys.DetonateWeapon then
		if warhead_master_arm then
			execute_detonation()
		end
	end
end

function CockpitEvent(event,val)
	if warhead_master_arm and fuse_armed and (event == "Crash" or event == "Kill" or event == "CrashPilot") then
		execute_detonation()
	end
end

function SetDamage(cell_id, severity)
	if warhead_master_arm and fuse_armed then
		execute_detonation()
	end
end

need_to_be_closed = false
