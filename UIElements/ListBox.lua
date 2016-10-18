--
-- ListBox
-- A list box.
--

local GUI = require("gui");
-- button element required for listbox only.
GUI.Button = require("UIElements.Button");
local vector2 = require("Vector2")
local vector3 = require("Vector3")
local UISkin = require("GUISkin")
local rectF = love.graphics.rectangle;

-- Returns the first element in a table including the key
-- from memory ipairs wont neccisarily select the first element...
-- todo: make this reliable.
local function getFirst(t)
	for k,v in pairs(t) do
		print("v", v)
		return v; -- exit immediately.
	end
end

--
-- Main ListBox construction function.
--
local ListBox = function( name, position, size, items )
	local component = GUI.CreateComponent( name, position, size, GUI.RenderListBox)
	-- standard properties
	component.textAlign = "left"; -- the text alignment left, center, right;
	component.status = false; -- used to handle change in the button.

	-- set up list objects but first check for errors!
	assert (items ~= nil);
	component.selected = getFirst(items);
	component.items = items;
	component.expanded = false;
	-- function pointer/event hook for later use.
	component.OnValueUpdated = function( value ) end

	-- this is broken
	component.mSelectedButton = GUI.Button("dropdown_test", position, size)
	component.mSelectedButton.buttonStateChanged = function( value )
		if value == true then
			component.expanded = not component.expanded;
			print("Expand control detected: ", component.expanded);
		end
	end

	return component;
end

-- Basic known limitations, no scroll bar yet!
GUI.RenderListBox = function( component, rootNode )
	-- is the listbox expanded.
		-- render the expanded objects of the list box.
	-- else
	-- CLEAR COLOUR reset to default for rendering.
	love.graphics.setColor(255,255,255)

	--- this isn't rendering
	local v = component.mSelectedButton;
	-- manual rendering test
	GUI.RenderButton( v, rootNode )
	--v:render(v);
	-- comp:render();
		-- display current value of object.
end

return ListBox;
