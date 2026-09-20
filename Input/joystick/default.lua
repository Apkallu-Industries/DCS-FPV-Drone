local cockpit = folder.."../../Cockpit/Scripts/"
dofile(cockpit.."devices.lua")
dofile(cockpit.."command_defs.lua")
local res = external_profile("Config/Input/Aircrafts/common_joystick_binding.lua")

-- down = single instance,  pressed = continuous input
join(res.keyCommands,{
    
	{combos = {{key = 'A'}}, down = Keys.ArmToggle, 	name = _('Toggle Drone Arm'), category = _('Flight Control')},
	{combos = {{key = 'JOY_BTN1'}}, down = Keys.ArmToggle, 	name = _('Toggle Drone Arm (Controller [A])'), category = _('Flight Control')},

    {combos = {{key = '1'}}, down = Keys.AcroMode, 		name = _('Flight Mode - Acro'), category = _('Flight Control')},
	{combos = {{key = 'JOY_BTN3'}}, down = Keys.AcroMode, 		name = _('Flight Mode - Acro (Controller [X])'), category = _('Flight Control')},
	{combos = {{key = 'JOY_POV1_D'}}, down = Keys.AcroMode, 	name = _('Flight Mode - Acro (Controller [D-Pad Down])'), category = _('Flight Control')},

	{combos = {{key = '2'}}, down = Keys.AngleMode, 	name = _('Flight Mode - Angle (Auto-Level)'), category = _('Flight Control')},
	{combos = {{key = 'JOY_BTN2'}}, down = Keys.AngleMode, 	name = _('Flight Mode - Angle (Controller [B])'), category = _('Flight Control')},
	{combos = {{key = 'JOY_POV1_U'}}, down = Keys.AngleMode, 	name = _('Flight Mode - Angle (Controller [D-Pad Up])'), category = _('Flight Control')},

	{combos = {{key = 'JOY_BTN4'}}, down = Keys.WarheadArmToggle, 	name = _('Toggle Warhead Arm/Disarm (Controller [Y])'), category = _('Weapons')},

	{combos = {{key = 'Space'}}, down = Keys.DetonateWeapon, 	name = _('Detonate Weapon'), category = _('Weapons')},
	{combos = {{key = 'JOY_BTN6'}}, down = Keys.DetonateWeapon, 	name = _('Detonate Weapon (Controller [RB])'), category = _('Weapons')},
	{combos = {{key = 'JOY_BTN5'}}, down = Keys.DetonateWeapon, 	name = _('Detonate Weapon (Controller [LB])'), category = _('Weapons')},
})

join(res.axisCommands,{
{combos = defaultDeviceAssignmentFor("roll")	, action = iCommandPlaneRoll,			name = _('Roll (Left Stick X)')},
{combos = defaultDeviceAssignmentFor("pitch")	, action = iCommandPlanePitch,			name = _('Pitch (Left Stick Y)')},
{combos = defaultDeviceAssignmentFor("rudder")	, action = iCommandPlaneRudder, 		name = _('Yaw (Right Stick X)')},
{combos = defaultDeviceAssignmentFor("thrust")	, action = iCommandPlaneThrustCommon,	name = _('Throttle (Left Trigger / Stick)')},
})
return res
