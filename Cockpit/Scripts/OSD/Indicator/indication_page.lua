dofile(LockOn_Options.script_path.."OSD/Indicator/definitions.lua")

addTexPoly("scanLines", MakeMaterial("FPV_Drone_Scanlines.png",{255,255,255,35}),{"Option_Scanline"},{{"parameter_in_range",0,1}} )

local modePos = {0.9*aspect,0.9}
addText("ACROlabel", "ACRO", modePos, {{"parameter_in_range",0,0}}, {"FlightMode"})
addText("Anglelabel", "ANGL", modePos, {{"parameter_in_range",0,1}}, {"FlightMode"})
--addText("Horizlabel", "HORIZON", modePos, {{"parameter_in_range",0,2}}, {"FlightMode"})

addText("ARMlabel", "DISARMED", {0,-0.25}, {{"parameter_in_range",0,0}}, {"isArmed"})
addText("WHSafeLabel", "WH SAFE", {0,-0.40}, {{"parameter_in_range",0,0}}, {"WarheadStatus"})
addText("WHLiveLabel", "WH LIVE", {0.9*aspect,0.80}, {{"parameter_in_range",0,1}}, {"WarheadStatus"})

addText("battVoltlabel", nil, {-0.9*aspect,0.95}, {{"text_using_parameter",0,0}}, {"BatteryVoltage"},{"%.1fv"})
addText("cellVoltlabel", nil, {-0.9*aspect,0.9}, {{"text_using_parameter",0,0}}, {"CellVoltage"},{"%.1fv"})
addText("chargelabel", nil, {-0.9*aspect,0.85}, {{"text_using_parameter",0,0}}, {"BatteryPercent"},{"%.0f %%"})


addTexPoly("crosshair", MakeMaterial("FPV_Drone_Crosshairs.png",{255,255,255,255}),nil,nil,(22/640),(18/480))

------- Control indicators ---------------
local cntrlWidth = 84/480 --0.2
local cntrlHeight = 84/640*aspect --0.2
local cntrl_L = {-0.3, -0.8-cntrlWidth}
local cntrl_R = {0.3, -0.8}

addTexPoly("LStickScale", MakeMaterial("FPV_Drone_StickOverlay.png",{255,255,255,255}),nil,nil,(84/640),(84/480),{-0.3, -0.8})
addTexPoly("LStickPos", MakeMaterial("FPV_Drone_StickSprite.png",{255,255,255,255}),{"THROTTLE_INPUT","YAW_INPUT"},{{"move_up_down_using_parameter",0, cntrlWidth*2},{"move_left_right_using_parameter",1, cntrlHeight}},(12/640),(18/480),cntrl_L)

addTexPoly("RStickScale", MakeMaterial("FPV_Drone_StickOverlay.png",{255,255,255,255}),nil,nil,(84/640),(84/480),cntrl_R)
addTexPoly("RStickPos", MakeMaterial("FPV_Drone_StickSprite.png",{255,255,255,255}),{"PITCH_INPUT","ROLL_INPUT"},{{"move_up_down_using_parameter",0, -cntrlWidth},{"move_left_right_using_parameter",1, cntrlHeight}},(12/640),(18/480),cntrl_R)


------ screen static when battery dies -----------
addTexPoly("screenStatic1", MakeMaterial("FPV_Drone_Static1.png",{255,255,255,255}), {"ScreenStatic"}, {{"parameter_in_range",0,1}} )
addTexPoly("screenStatic2", MakeMaterial("FPV_Drone_Static2.png",{255,255,255,255}), {"ScreenStatic"}, {{"parameter_in_range",0,2}} )
addTexPoly("screenStatic3", MakeMaterial("FPV_Drone_Static3.png",{255,255,255,255}), {"ScreenStatic"}, {{"parameter_in_range",0,3}} )
addTexPoly("screenStatic4", MakeMaterial("FPV_Drone_Static4.png",{255,255,255,255}), {"ScreenStatic"}, {{"parameter_in_range",0,4}} )
