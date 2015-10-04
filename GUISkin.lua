-- A default skin to be used by the GUI Controls.
-- Used as an example, not as really part of the API in some small cases.
-- FORMAT: (x)R,(y)B,(z)G - RBG colours.
local function GetDefaultSkin()
	return {
		['default'] = {255,255,255},		-- ideally (arg[0] ~= nil ? arg[0] : Vector3(100,100,100)) but no bitop.
		['hover'] = {200,200,200}, -- ideally || arg[1]
		['active'] = {255,255,255}, -- ideally || arg[2]
		['background'] = {255,255,255,235}, -- ideally || arg[3]
	}
end

return {
	['button'] = GetDefaultSkin(),
	['pane'] = GetDefaultSkin(),
	['TextInput'] = GetDefaultSkin(),
}