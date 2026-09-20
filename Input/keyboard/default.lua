local cockpit = folder.."../../Cockpit/Scripts/"
dofile(cockpit.."devices.lua")
dofile(cockpit.."command_defs.lua")
local res = external_profile("Config/Input/Aircrafts/common_keyboard_binding.lua")

-- down = single instance,  pressed = continuous input
join(res.keyCommands,{

	{combos = {{key = 'A'}}, down = Keys.ArmToggle, 	name = _('Toggle Drone Arm'), category = _('Flight Control')},

    {combos = {{key = '1'}}, down = Keys.AcroMode, 		name = _('Flight Mode - Acro'), category = _('Flight Control')},
	{combos = {{key = '2'}}, down = Keys.AngleMode, 	name = _('Flight Mode - Angle (Auto-Level)'), category = _('Flight Control')},
	
	{combos = {{key = 'Space'}}, down = Keys.DetonateWeapon, 	name = _('Detonate Weapon'), category = _('Weapons')},
	{combos = {{key = 'Y'}}, down = Keys.WarheadArmToggle, 	name = _('Toggle Warhead Arm/Disarm [Y]'), category = _('Weapons')},

	-- Throttle (Altitude / Climb)
	{combos = {{key = 'PageUp'}}, down = Keys.ThrottleUp, up = Keys.ThrottleUp, value_down = 1.0, value_up = 0.0, name = _('Throttle Up (Climb) [PageUp]'), category = _('Flight Control')},
	{combos = {{key = 'PageDown'}}, down = Keys.ThrottleDown, up = Keys.ThrottleDown, value_down = 1.0, value_up = 0.0, name = _('Throttle Down (Descend) [PageDn]'), category = _('Flight Control')},
	{combos = {{key = 'W'}}, down = Keys.ThrottleUp, up = Keys.ThrottleUp, value_down = 1.0, value_up = 0.0, name = _('Throttle Up (Climb) [W]'), category = _('Flight Control')},
	{combos = {{key = 'S'}}, down = Keys.ThrottleDown, up = Keys.ThrottleDown, value_down = 1.0, value_up = 0.0, name = _('Throttle Down (Descend) [S]'), category = _('Flight Control')},
	{combos = {{key = 'H'}}, down = Keys.ThrottleHover, name = _('Throttle Auto-Hover Preset [H]'), category = _('Flight Control')},
	{combos = {{key = 'C'}}, down = Keys.ThrottleCut, name = _('Throttle Cut [C]'), category = _('Flight Control')},

	-- Pitch (Forward / Backward tilt)
	{combos = {{key = 'Up'}}, down = Keys.PitchDown, up = Keys.PitchDown, value_down = 1.0, value_up = 0.0, name = _('Pitch Forward (Tilt Down) [Up Arrow]'), category = _('Flight Control')},
	{combos = {{key = 'Down'}}, down = Keys.PitchUp, up = Keys.PitchUp, value_down = 1.0, value_up = 0.0, name = _('Pitch Backward (Tilt Up) [Down Arrow]'), category = _('Flight Control')},

	-- Roll (Bank Left / Right)
	{combos = {{key = 'Left'}}, down = Keys.RollLeft, up = Keys.RollLeft, value_down = 1.0, value_up = 0.0, name = _('Roll Left [Left Arrow]'), category = _('Flight Control')},
	{combos = {{key = 'Right'}}, down = Keys.RollRight, up = Keys.RollRight, value_down = 1.0, value_up = 0.0, name = _('Roll Right [Right Arrow]'), category = _('Flight Control')},

	-- Yaw (Rudder / Heading rotation)
	{combos = {{key = 'Q'}}, down = Keys.YawLeft, up = Keys.YawLeft, value_down = 1.0, value_up = 0.0, name = _('Yaw Left [Q]'), category = _('Flight Control')},
	{combos = {{key = 'E'}}, down = Keys.YawRight, up = Keys.YawRight, value_down = 1.0, value_up = 0.0, name = _('Yaw Right [E]'), category = _('Flight Control')},
	{combos = {{key = 'Z'}}, down = Keys.YawLeft, up = Keys.YawLeft, value_down = 1.0, value_up = 0.0, name = _('Yaw Left [Z]'), category = _('Flight Control')},
	{combos = {{key = 'X'}}, down = Keys.YawRight, up = Keys.YawRight, value_down = 1.0, value_up = 0.0, name = _('Yaw Right [X]'), category = _('Flight Control')},
})
return res



