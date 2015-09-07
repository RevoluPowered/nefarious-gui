-- SUPER LUPA GUI LIBRARY BECAUSE FUCK YOU THATS WHY --
local vector2 = require("vector2")
local vector3 = require("vector3")
local GUI = {}

local rectF = love.graphics.rectangle

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

-- Component is the local object, the rootnode is the parent which is supplied for the offset.
GUI.RenderButton = function( component, rootNode )
	local pos = component.pos + rootNode.pos;
	local size = component.size;
	local text = component.name;
	love.graphics.setColor(255,255,255)
	local offset = love.graphics.getFont():getWidth(text)
	
	
	-- Check button mousebounds for hover over effect to see if its required.
	if( GUI.MouseBounds(pos, Vector2( offset + 20, size.y))) then
	
		love.graphics.setColor(230,230,230)
		rectF("fill", pos.x, pos.y, offset + 20, size.y)
	
		if( love.mouse.isDown('l')) then
			--love.graphics.setColor(255,0,0)
		else
			--love.graphics.setColor(0,255,0)
		end
	else
		love.graphics.setColor(255,255,255)
		rectF("fill", pos.x, pos.y, offset + 20, size.y)
		love.graphics.setColor(0,0,0)
	end
	love.graphics.setColor(0,0,0)
	-- Render on screen (text)
	love.graphics.print( text, pos.x + 10, pos.y + 5)
end

-- At the minute this doesn't actually make sense to use, however later I will be adding in some component based logic.
GUI.CreateComponent = function( name, pos, size, renderfunc  )
	return {
		--['Visible'] = true,
		--['Enabled'] = true, -- if this isn't enabled the controls on a UI generally go to a darker colour.
		--['Layer'] = 0; -- the numbers of layers will be sorted by 0 ... 99 with the lower number being first in the queue.
		['name'] = name,
		['pos'] = pos,	
		['size'] = size,
		['render'] = renderfunc, -- the default render function. normally really a specifier for the type of component or at least its render behaviour.
	}
end

local baseSkin = {
	['hover'] = Vector3(200,200,200),
	['active'] = Vector3(255,255,255),
	['text-hover'] = Vector3(255,255,255),
	['text-active'] = Vector3(255,255,255)
}


GUI.CreatePane = function( name, pos, size )
	local component = GUI.CreateComponent( name, pos, size );
	function component.render( self )
		-- Just a debug background for the pane.
		love.graphics.setColor(200,200,200)
		rectF("fill", self.pos.x, self.pos.y, self.size.x, self.size.y)
		love.graphics.setColor(255,255,255)
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
		print("Added component to pane")
		table.insert(self.components, component );	
	end	
	
	component.components = {}
	return component;	
end


-- backend 
-- #automatic layer sorting and rendering for ui components.
-- #skining functionality for components.
-- #event support so that for instance some new gui events exist including: control.activated, control.changed, etc... perhaps even just a pointer to an activate function blargh. notes..


-- frontend
-- #simple user interface
-- #easy to use and adjustable without complications.
-- #skinable interface
-- #buttons, text boxes, input boxes,images, panels, frames, iframes?, custom interfaces for custom controls.

-- this should actually return a 'gui.component' object as this can then be used to create a procedural user interface from different components and accessable later from a lua table.




return GUI;