--
-- TEXT Input
--

local GUI = require("gui")
local vector2 = require("Vector2")
local vector3 = require("Vector3")
local UISkin = require("GUISkin")
local rectF = love.graphics.rectangle;

-- Text input - this is for putting in information.
local TextInput = function( name, position, size )
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
		if( love.mouse.isDown(1)) then
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

return TextInput
