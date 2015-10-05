--
-- GUI
-- Authored by Gordon Alexander MacPherson
local vector2 = require("vector2")
local vector3 = require("vector3")
local UISkin = require("GUISkin")

local GUI = {}


local rectF = love.graphics.rectangle;


-- function to check if mouse is between the bounds of the specified element.
GUI.MouseBounds = function( pos, size )
	local x, y = love.mouse.getPosition();
	
	local boundRight = pos.x + size.x;
	local boundBottomRight = pos.y + size.y;
	
	if( x >= pos.x and x <= boundRight and y >= pos.y and y <= boundBottomRight ) then
		return true;
	else
		return false;
	end
end

GUI.MinTextWidth = function( text )
	return love.graphics.getFont():getWidth(text) + 20 -- including borders width.
end

-- Event handling needed added:
-- KeyPressed, KeyReleased.
-- MousePressed
-- MouseReleased 
-- So input.buttonDown will only return true once until the key or button has been released again.
-- This is like OIS or for example even unity.


-- Simpler API instead of assigning render functions which should be hidden in the backround of the system.


GUI.Components = {}

-- At the minute this doesn't actually make sense to use, however later I will be adding in some component based logic.
GUI.CreateComponent = function( name, pos, size, renderfunc )	 

	-- Return the default table.
	local tbl = {
		--['Visible'] = true,
		--['Enabled'] = true, -- if this isn't enabled the controls on a UI generally go to a darker colour.
		--['Layer'] = 0; -- the numbers of layers will be sorted by 0 ... 99 with the lower number being first in the queue.
		['name'] = name,
		['pos'] = pos,	
		['size'] = size,
		['render'] = renderfunc, -- the default render function. normally really a specifier for the type of component or at least its render behaviour.
		['enableKeyboard'] = false, 
	}
	
	-- Register the new GUI Component.
	table.insert( GUI.Components, tbl )
	
	-- Return the new component.
	return tbl;
end



GUI.CreatePane = function( name, pos, size )
	-- Create a component.
	local component = GUI.CreateComponent( name, pos, size );
	function component.render( self )
		-- Just a debug background for the pane.
		love.graphics.setColor(UISkin.pane.background) -- The pane background colour.
		rectF("fill", self.pos.x, self.pos.y, self.size.x, self.size.y)
		
		-- CLEAR COLOUR reset to default for rendering.
		love.graphics.setColor(UISkin.pane.default)
		
		-- Render each component
		for i in ipairs(self.components) do
			local comp = self.components[i]
			comp:render(self)
		end
	end
	-- Pane.AddComponent function.
	-- Allows you to add components to an object for rendering.
	component.AddComponent = function( self, component )
		if component == nil then return end;
		print("Added component to pane.")
		table.insert(self.components, component );	
	end	
	
	component.components = {}
	return component;	
end


-- Backend 
-- #automatic layer sorting and rendering for ui components.
-- #skining functionality for components.
-- #event support so that for instance some new gui events exist including: control.activated, control.changed, etc... perhaps even just a pointer to an activate function blargh. notes..


-- Frontend
-- #simple user interface
-- #easy to use and adjustable without complications.
-- #skinable interface
-- #buttons, text boxes, input boxes,images, panels, frames, iframes?, custom interfaces for custom controls.

--[[ 
Completed:
	buttons,
	text input,
	images,
	panels,
	
Todo:
	(high priority)
	list box
	dialog / draggable windows
	(low priority)
	textbox - with auto text wrapping. 
	frames - perhaps, not too sure about this yet.0
]]


-- this should actually return a 'gui.component' object as this can then be used to create a procedural user interface from different components and accessable later from a lua table.




return GUI;