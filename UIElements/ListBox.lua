--
-- ListBox
-- A list box.
-- 

local GUI = require("gui")
local vector2 = require("vector2")
local vector3 = require("vector3")
local UISkin = require("GUISkin")
local rectF = love.graphics.rectangle;

-- Returns the first element in a table including the key 
-- from memory ipairs wont neccisarily select the first element...
-- todo: make this reliable.
local function getFirst(t)
	for k,v in pairs(t) do
		return
		{
			["k"] = k,
			["v"] = v
		}
	end	
end


local ListBox = function( name, position, size, items )
	local component = GUI.CreateComponent( name, position, size, GUI.RenderListBox)
	component.textAlign = "left"; -- the text alignment left, center, right;
	component.status = false; -- used to handle change in the button.
	if items ~= nil then
		component.selected = getFirst(items);
		component.items = items; -- a table, indexed by strings as keys, the values are functions.
	end
	return component;
end

-- Example item table
local example =
{
	["File"] = function() print("File button.") end,
	["Open"] = function() print("Open button.") end
}

local RenderSelectionButton = function( text, position, size, returnValue )
 -- todo.
end




GUI.RenderListBox = function( component, rootNode )
	if component.items == nil then 
		component.items = example;
		component.selected = getFirst(example);
		
	end
	
	-- Component properties.
	local pos = component.pos + rootNode.pos;
	local size = component.size;
	
	-- Is the dropdown expanded.
	if(component.expanded == true) then
		-- render expanded.
		
	else
		
end

return ListBox;