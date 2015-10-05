--
-- GUI
-- Authored by Gordon Alexander MacPherson
local vector2 = require("vector2")
local vector3 = require("vector3")
local UISkin = require("GUISkin")

local GUI = {}
local rectF = love.graphics.rectangle

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

--
-- Image
-- images will be loaded ONLY from the data folder.
GUI.Image = function( name, position, imagePath, scale )
	-- Set scale.
	if scale == nil then scale = Vector2(1,1) end
	
	local image = love.graphics.newImage("Data/" .. imagePath);

	local component = GUI.CreateComponent( name, position, size, function( component, rootNode )
		local pos = component.pos + rootNode.pos;
		local size = component.size;
		-- render image.
		love.graphics.setColor(255,255,255);
		love.graphics.draw(component.image, pos.x, pos.y, 0, scale.x, scale.y)
		love.graphics.setColor(0,0,0);
	end)
	
	-- Assign image to local self.
	component.image = image;
	
	return component;
end

--
-- Label
--
GUI.Label = function( name, position, size )
	local component = GUI.CreateComponent( name, position, size, GUI.RenderLabel)
	component.textAlign = "left"; -- the text alignment left, center, right;
	return component;
end

-- Component is the local object, the rootnode is the parent which is supplied for the offset.
GUI.RenderLabel = function( component, rootNode )
	local pos = component.pos + rootNode.pos;
	local size = component.size;
	local text = component.name;
	
	-- Clear COLOUR
	love.graphics.setColor(UISkin.button.default)
	local textWidth = love.graphics.getFont():getWidth(text)
	
	local textXpos = pos.x;
	
	
	--
	-- Text alignment.
	--	
	if(component.textAlign == "left") then
		textXpos = textXpos;
	elseif (component.textAlign == "center") then
		textXpos = textXpos + ((size.x / 2) - (textWidth / 2)); -- offset must also be by the actual width of the text logically.
	elseif (component.textAlign == "right") then
		assert(textWidth <= size.x) -- throw an error if an issue arises
		--textXpos = textWidth
		textXpos = textXpos +(size.x - (textWidth));
	end
	
	
	love.graphics.setColor(0,0,0)
	-- Render on screen (text)
	love.graphics.print( text, textXpos, pos.y + 5)
end

--
-- BUTTON 
--

-- This allows also custom construction of properties to be added to the elements.
GUI.Button = function( name, position, size )
	local component = GUI.CreateComponent( name, position, size, GUI.RenderButton)
	component.status = false;
	component.textAlign = "center"; -- the text alignment left, center, right;
	component.buttonStateChanged = function (v) end;
	return component;
end

-- Component is the local object, the rootnode is the parent which is supplied for the offset.
GUI.RenderButton = function( component, rootNode )
	local pos = component.pos + rootNode.pos;
	local size = component.size;
	local text = component.name;
	
	-- Clear COLOUR
	love.graphics.setColor(UISkin.button.default)
	local textWidth = love.graphics.getFont():getWidth(text)
	
	local textXpos = pos.x;
	
	
	--
	-- Text alignment.
	--	
	if(component.textAlign == "left") then
		textXpos = textXpos + 10;
	elseif (component.textAlign == "center") then
		textXpos = textXpos + ((size.x / 2) - (textWidth / 2)); -- offset must also be by the actual width of the text logically.
	elseif (component.textAlign == "right") then
		assert(textWidth <= size.x) -- throw an error if an issue arises
		--textXpos = textWidth
		textXpos = textXpos +(size.x - (textWidth + 10));
	end
	
	
	-- Check button mousebounds for hover over effect to see if its required.
	if( GUI.MouseBounds(pos, Vector2( size.x, size.y))) then
		-- GUI BUTTON hover
		love.graphics.setColor(UISkin.button.hover)
		rectF("fill", pos.x, pos.y, size.x, size.y)
		
		-- GUI BUTTON activate
		if( love.mouse.isDown('l')) then
			love.graphics.setColor(UISkin.button.active);
			-- validate the status has at least been reset before calling this again otherwise it will constantly be updated.
			if component.status ~= true then
				component.status = true
				component.buttonStateChanged( true );
			end
		else
			-- validate the status has at least been reset before calling this again otherwise it will constantly be updated.
			if component.status ~= false then
				component.status = false
				component.buttonStateChanged( false );
			end
		end
	else
		-- GUI BUTTON background
		love.graphics.setColor(UISkin.button.default)
		rectF("fill", pos.x, pos.y, size.x, size.y)
		love.graphics.setColor(0,0,0)
		component.status = false
	end
	love.graphics.setColor(0,0,0)
	-- Render on screen (text)
	love.graphics.print( text, textXpos, pos.y + 5)
end

--
-- TEXT Input
--

-- Text input - this is for putting in information.
GUI.TextInput = function( name, position, size )
	local component = GUI.CreateComponent( name, position, size, GUI.RenderTextInput)	
	component.value = "";
	component.enableKeyboard = true;
	component.textAlign = "center"; -- the text alignment left, center, right;
	component.maxChars = 16;
	component.placeholder = "placeholder";
	component.KeyPressed = function( key )		
		-- Adding handling for backspace chars.
		if key == "backspace" then
			--print("backspace found");
			component.value = component.value:sub(1,-2);
			return; -- exit as we're done.
		end
		
		-- if value >= maxwidth  
		-- how do i get the count of the chars that can fit within the text box without changing the width dynamically?
		local lenght = love.graphics.getFont():getWidth(component.value)
		if #component.value >= component.maxChars then return end 
		print("Debug control: " .. key)
		
		-- Calculate width based upon the text string, so a max width variable must be first checked before updating the text value?! or alternatively something else?
		component.value = component.value .. key;		
	end
	
	return component;	
end

-- Component is the local object, the rootnode is the parent which is supplied for the offset.
GUI.RenderTextInput = function( component, rootNode )
	local pos = component.pos + rootNode.pos;
	local size = component.size;
	local text = component.name;
	
	-- Clear COLOUR
	love.graphics.setColor(UISkin.button.default)
	
	-- set the offset
	local offset = love.graphics.getFont():getWidth(component.value)
	
	-- Check button mousebounds for hover over effect to see if its required.
	if( GUI.MouseBounds(pos, Vector2( size.x, size.y))) then
		-- GUI BUTTON hover
		love.graphics.setColor(UISkin.button.hover)
		rectF("fill", pos.x, pos.y, size.x, size.y)
		
		-- GUI BUTTON activate
		if( love.mouse.isDown('l')) then
			love.graphics.setColor(UISkin.button.active)
			component.status = true
		else
			component.status = false
			--love.graphics.setColor(0,255,0)
		end
	else
		-- GUI BUTTON background
		love.graphics.setColor(UISkin.button.default)
		rectF("fill", pos.x, pos.y, size.x, size.y)
		love.graphics.setColor(0,0,0)
		component.status = false
	end
	love.graphics.setColor(0,0,0)
	-- Render on screen (text)
	if #component.value == 0 then
		-- Set color to placeholder skin
		love.graphics.setColor(UISkin.button.placeholder)
		love.graphics.print( component.placeholder, pos.x + 10, pos.y + 5)
	else
		love.graphics.print( component.value, pos.x + 10, pos.y + 5)
	end
	
	-- Reset colour
	love.graphics.setColor(0,0,0)
end


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
	(low priority)
	textbox - with auto text wrapping. 
	frames - perhaps, not too sure about this yet.0
]]


-- this should actually return a 'gui.component' object as this can then be used to create a procedural user interface from different components and accessable later from a lua table.




return GUI;