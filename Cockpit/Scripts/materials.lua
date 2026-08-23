dofile(LockOn_Options.common_script_path.."Fonts/symbols_locale.lua")
dofile(LockOn_Options.common_script_path.."Fonts/fonts_cmn.lua")

-------MATERIALS-------
materials = {}   
materials["OSD_WHITE"] = {255,255,255,255}

-------TEXTURES-------
textures = {}

-------FONTS----------
fontdescription = {}
local symbol_pixels_x = 12 
local symbol_pixels_y = 18
fontdescription["font_OSD"]  = {
--local font_desc = {
	texture     = LockOn_Options.script_path.."../../Textures/FPV_Drone_font.png",
	size        = {3, 16},
	resolution  = {207, 56},
	default     = {symbol_pixels_x, symbol_pixels_y},
	chars	    = {
		[1]  = {48, symbol_pixels_x, symbol_pixels_y}, -- 0
		[2]  = {49, symbol_pixels_x, symbol_pixels_y}, -- 1
		[3]  = {50, symbol_pixels_x, symbol_pixels_y}, -- 2
		[4]  = {51, symbol_pixels_x, symbol_pixels_y}, -- 3
		[5]  = {52, symbol_pixels_x, symbol_pixels_y}, -- 4
		[6]  = {53, symbol_pixels_x, symbol_pixels_y}, -- 5
		[7]  = {54, symbol_pixels_x, symbol_pixels_y}, -- 6
		[8]  = {55, symbol_pixels_x, symbol_pixels_y}, -- 7
		[9]  = {56, symbol_pixels_x, symbol_pixels_y}, -- 8
		[10] = {57, symbol_pixels_x, symbol_pixels_y}, -- 9
		[11] = {symbol[':'], symbol_pixels_x, symbol_pixels_y},
		[12] = {symbol[';'], symbol_pixels_x, symbol_pixels_y},		 
		[13] = {symbol['<'], symbol_pixels_x, symbol_pixels_y},
		[14] = {symbol['='], symbol_pixels_x, symbol_pixels_y},
		[15] = {symbol['>'], symbol_pixels_x, symbol_pixels_y},
		[16] = {symbol['%'], symbol_pixels_x, symbol_pixels_y},
		[17] = {32, symbol_pixels_x, symbol_pixels_y}, -- [space]
		[18] = {65, symbol_pixels_x, symbol_pixels_y}, -- A
		[19] = {66, symbol_pixels_x, symbol_pixels_y}, -- B
		[20] = {67, symbol_pixels_x, symbol_pixels_y}, -- C
		[21] = {68, symbol_pixels_x, symbol_pixels_y}, -- D
		[22] = {69, symbol_pixels_x, symbol_pixels_y}, -- E
		[23] = {70, symbol_pixels_x, symbol_pixels_y}, -- F
		[24] = {71, symbol_pixels_x, symbol_pixels_y}, -- G
		[25] = {72, symbol_pixels_x, symbol_pixels_y}, -- H
		[26] = {73, symbol_pixels_x, symbol_pixels_y}, -- I
		[27] = {74, symbol_pixels_x, symbol_pixels_y}, -- J
		[28] = {75, symbol_pixels_x, symbol_pixels_y}, -- K
		[29] = {76, symbol_pixels_x, symbol_pixels_y}, -- L
		[30] = {77, symbol_pixels_x, symbol_pixels_y}, -- M
		[31] = {78, symbol_pixels_x, symbol_pixels_y}, -- N
		[32] = {79, symbol_pixels_x, symbol_pixels_y}, -- O
		[33] = {80, symbol_pixels_x, symbol_pixels_y}, -- P
		[34] = {81, symbol_pixels_x, symbol_pixels_y}, -- Q
		[35] = {82, symbol_pixels_x, symbol_pixels_y}, -- R
		[36] = {83, symbol_pixels_x, symbol_pixels_y}, -- S
		[37] = {84, symbol_pixels_x, symbol_pixels_y}, -- T
		[38] = {85, symbol_pixels_x, symbol_pixels_y}, -- U
		[39] = {86, symbol_pixels_x, symbol_pixels_y}, -- V
		[40] = {87, symbol_pixels_x, symbol_pixels_y}, -- W
		[41] = {88, symbol_pixels_x, symbol_pixels_y}, -- X
		[42] = {89, symbol_pixels_x, symbol_pixels_y}, -- Y
		[43] = {90, symbol_pixels_x, symbol_pixels_y}, -- Z	
		[44] = {symbol['['], symbol_pixels_x, symbol_pixels_y}, 
		[45] = {symbol['\\'], symbol_pixels_x, symbol_pixels_y}, -- \
		[46] = {symbol[']'], symbol_pixels_x, symbol_pixels_y}, 
		[47] = {latin['v'], symbol_pixels_x, symbol_pixels_y}, 	 
		[48] = {symbol['.'], symbol_pixels_x, symbol_pixels_y}
		}
}
OSD_font = MakeFont(fontdescription["font_OSD"],materials["OSD_WHITE"],"OSD_font")

fonts = {}
--fonts["OSD_indication_font"]	= {fontdescription["font_OSD"], 10, materials["OSD_WHITE"]}

