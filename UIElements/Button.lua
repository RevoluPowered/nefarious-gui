--
-- BUTTON 
--
local GUI = require("gui")
local vector2 = require("vector2")
local vector3 = require("vector3")
local UISkin = require("GUISkin")
local rectF = love.graphics.rectangle;

-- This allows also custom construction of properties to be added to the elements.
local Button = function( name, position, size )
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
	
	if component.name == "dropdown_test2" then
		print("DEBUG CLASS DETECTED");
	end
	
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

return Button;
