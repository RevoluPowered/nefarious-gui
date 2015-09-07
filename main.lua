
-- optimize: add event so that the objects and mouse position are only checked when they change instead of each tick.


local utf8 = require("utf8")
local rectF = love.graphics.rectangle

local commandText = "_"
local mouseImagePath = "Data/cursor.png"

local vector2 = require("vector2")
local GUI = require("gui")


function love.load()
	love.keyboard.setKeyRepeat(true)
	love.window.setTitle("Chat Application [Version: 0x01]")
	--local cursor = love.mouse.newCursor( mouseImagePath )
	--love.mouse.setCursor( cursor )
	love.mouse.setGrabbed( true )
end


-- 					  --
-- - INPUT HANDLING - --
--					  --

-- Handle text being entered.
function love.textinput(t)
	commandText = commandText .. t
end

function love.keypressed(key)
	if key == "backspace" then
		local byteoffset = utf8.offset(commandText, -1)
		if byteoffset then
			commandText = string.sub(commandText, 1, byteoffset - 1)
		end
	end
end
--[[

Example control addition usage:

local examplecontrol = 
{ 
	ControlName,
	DrawOrder,
	[Size]{X,Y},
	[Position]{X, Y},
	DrawFunction
}

local localControl =
{
	[Size]{ X, Y },
	[Position]{ X, Y}
}


defineControl( "myname", 20, etc... )
]]--




local button = GUI.CreateComponent( "ExampleComponent", Vector2(25,25), Vector2(75, 25), GUI.RenderButton)
local pane = GUI.CreatePane("Main Pane", Vector2(65,0), Vector2(600, 400))
pane:AddComponent( button );

function love.draw()
	pane:render()
	-- Render Button
	-- GUI.RenderButton("Button X", Vector2(0, 0), Vector2(75, 25))	
	
	-- GUI.RenderButton("Another button", Vector2(80, 0), Vector2(75, 25))
	--GUI.RenderButton("Button X", Vector2(25, 25), Vector2(75, 65))	
	--GUI.RenderButton("Hello World", Vector2(45, 45), Vector2(75, 25))	
	--GUI.RenderButton("Detonate", Vector2(85, 67), Vector2(75, 25))	
end