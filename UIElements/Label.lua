--
-- Label
--
local GUI = require("gui")
local vector2 = require("vector2")
local vector3 = require("vector3")
local UISkin = require("GUISkin")
local rectF = love.graphics.rectangle;


Label = function( name, position, size )
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

return Label;