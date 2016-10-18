--
-- Image
-- images will be loaded ONLY from the data folder.
--

local GUI = require("gui")
local vector2 = require("Vector2")
local vector3 = require("Vector3")
local UISkin = require("GUISkin")
local rectF = love.graphics.rectangle;

local Image = function( name, position, imagePath, scale )
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

return Image;
