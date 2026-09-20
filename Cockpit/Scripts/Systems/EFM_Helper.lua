dofile(LockOn_Options.script_path.."command_defs.lua")

-- This device is used to help initialize clickable switches and to interface keyboard bindings with clickables
-- performClickableAction doesn't seem to send the command to the EFM, so dispatch_action is used for that

local update_rate = 0.02
make_default_activity(update_rate)
local dev = GetSelf()

local BatteryPercent  = get_param_handle("BatteryPercent")-- from EFM
local isArmed  = get_param_handle("isArmed")
local FlightMode  = get_param_handle("FlightMode")

local PITCH_INPUT     = get_param_handle("PITCH_INPUT")
local THROTTLE_INPUT  = get_param_handle("THROTTLE_INPUT")

local ScreenStatic  = get_param_handle("ScreenStatic")
local DroneDestroyed = get_param_handle("DroneDestroyed")

-- special options
local option_maxYawRate = get_plugin_option_value("FPV_Drone","maxYawRate","local")
local Option_YawRate  = get_param_handle("Option_YawRate")

local option_maxPitchRollRate = get_plugin_option_value("FPV_Drone","maxPitchRollRate","local")
local Option_PitchRollRate  = get_param_handle("Option_PitchRollRate")

local option_maxAngle = get_plugin_option_value("FPV_Drone","maxAngle","local")
local Option_Angle  = get_param_handle("Option_Angle")

local option_gravityMult = get_plugin_option_value("FPV_Drone","gravity","local")
local Option_Gravity  = get_param_handle("Option_Gravity")

local option_scanlines = get_plugin_option_value("FPV_Drone","scanLineEffect","local")
local Option_Scanline  = get_param_handle("Option_Scanline")

function post_initialize()
	-- Always Auto-Arm on spawn and enable self-leveling Angle Mode!
	isArmed:set(1)
	FlightMode:set(1)
	ScreenStatic:set(0)
	
	Option_YawRate:set(option_maxYawRate)
	Option_PitchRollRate:set(option_maxPitchRollRate)
	Option_Angle:set(option_maxAngle)
	Option_Gravity:set(option_gravityMult)
	if option_scanlines then	
		Option_Scanline:set(1)
	else
		Option_Scanline:set(0)
	end
	
	set_aircraft_draw_argument_value(38, 1)-- so "cockpit" noise matches external
	
	--show_param_handles_list()--see all param handles in-game
end

dev:listen_command(Keys.ArmToggle)
dev:listen_command(Keys.AcroMode)
dev:listen_command(Keys.AngleMode)
dev:listen_command(Keys.HorizonMode)

dev:listen_command(Keys.ThrottleUp)
dev:listen_command(Keys.ThrottleDown)
dev:listen_command(Keys.PitchDown)
dev:listen_command(Keys.PitchUp)
dev:listen_command(Keys.RollLeft)
dev:listen_command(Keys.RollRight)
dev:listen_command(Keys.YawLeft)
dev:listen_command(Keys.YawRight)
dev:listen_command(Keys.ThrottleHover)
dev:listen_command(Keys.ThrottleCut)

local kb_pitch = 0.0
local kb_roll = 0.0
local kb_yaw = 0.0
local kb_thrust = 0.0

local pressing_th_up = false
local pressing_th_dn = false
local pressing_pitch_dn = false
local pressing_pitch_up = false
local pressing_roll_l = false
local pressing_roll_r = false
local pressing_yaw_l = false
local pressing_yaw_r = false
local hover_locked = false
local kb_active = false

function SetCommand(command,value)
	if DroneDestroyed:get() == 1 then
		return
	end
	if command == Keys.ArmToggle then
		isArmed:set(1-isArmed:get())
	elseif command==Keys.AcroMode then
		FlightMode:set(0)
	elseif command==Keys.AngleMode then
		FlightMode:set(1)
	elseif command==Keys.HorizonMode then	
		FlightMode:set(2)
	elseif command == Keys.ThrottleUp then
		pressing_th_up = (value > 0)
		kb_active = true
	elseif command == Keys.ThrottleDown then
		pressing_th_dn = (value > 0)
		kb_active = true
	elseif command == Keys.ThrottleHover then
		if hover_locked then
			hover_locked = false
			kb_thrust = 0.0
		else
			hover_locked = true
			kb_thrust = 0.55
			kb_active = true
		end
	elseif command == Keys.ThrottleCut then
		hover_locked = false
		kb_thrust = 0.0
		kb_active = true
	elseif command == Keys.PitchDown then
		pressing_pitch_dn = (value > 0)
		kb_active = true
	elseif command == Keys.PitchUp then
		pressing_pitch_up = (value > 0)
		kb_active = true
	elseif command == Keys.RollLeft then
		pressing_roll_l = (value > 0)
		kb_active = true
	elseif command == Keys.RollRight then
		pressing_roll_r = (value > 0)
		kb_active = true
	elseif command == Keys.YawLeft then
		pressing_yaw_l = (value > 0)
		kb_active = true
	elseif command == Keys.YawRight then
		pressing_yaw_r = (value > 0)
		kb_active = true
	end
end

function CockpitEvent(event,val)
end

local counter = 1
function update()
	local is_dead = (DroneDestroyed:get() == 1) or (BatteryPercent:get() <= 0)
	
	if is_dead or BatteryPercent:get() <= 1 then
		ScreenStatic:set(counter)
		counter = counter + 1
		if counter > 4 then
			counter = 1
		end
	else
		ScreenStatic:set(0)
	end

	-- If dead or disarmed, completely kill engine power and cease flight processing
	if is_dead or isArmed:get() == 0 then
		if dispatch_action then
			dispatch_action(0, 2004, 0.0)
		end
		return
	end

	-- Keyboard Flight Control Processing
	if kb_active then
		-- Throttle Accumulator
		if pressing_th_up then
			kb_thrust = math.min(1.0, kb_thrust + 0.6 * update_rate)
		elseif pressing_th_dn then
			kb_thrust = math.max(0.0, kb_thrust - 0.6 * update_rate)
		end

		if hover_locked then
			kb_thrust = math.max(0.55, kb_thrust)
		end

		-- Target Pitch (Forward / Backward tilt)
		local target_pitch = 0.0
		if pressing_pitch_dn then
			target_pitch = -0.70
		elseif pressing_pitch_up then
			target_pitch = 0.70
		end
		kb_pitch = kb_pitch + (target_pitch - kb_pitch) * math.min(1.0, 12.0 * update_rate)

		-- Target Roll (Bank Left / Right)
		local target_roll = 0.0
		if pressing_roll_l then
			target_roll = -0.70
		elseif pressing_roll_r then
			target_roll = 0.70
		end
		kb_roll = kb_roll + (target_roll - kb_roll) * math.min(1.0, 12.0 * update_rate)

		-- Target Yaw (Rudder rotation)
		local target_yaw = 0.0
		if pressing_yaw_l then
			target_yaw = -0.75
		elseif pressing_yaw_r then
			target_yaw = 0.75
		end
		kb_yaw = kb_yaw + (target_yaw - kb_yaw) * math.min(1.0, 12.0 * update_rate)

		-- Dispatch directly into DCS EFM
		if dispatch_action then
			dispatch_action(0, 2001, kb_pitch)
			dispatch_action(0, 2002, kb_roll)
			dispatch_action(0, 2003, kb_yaw)
			dispatch_action(0, 2004, kb_thrust)
		end
	end
end


need_to_be_closed = false -- close lua state after initialization