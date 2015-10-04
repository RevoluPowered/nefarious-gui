
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
	
	for k, v in pairs(GUI.Components) do
		if( v.enableKeyboard == true and v.KeyPressed ~= nil) then
			v.KeyPressed( t )
		end	
	end
end


function love.keypressed(key)
	if key == "backspace" then
		local byteoffset = utf8.offset(commandText, -1)
		if byteoffset then
			commandText = string.sub(commandText, 1, byteoffset - 1)
		end
	end
	
	-- send events to gui elements that require input being sent to them.
	-- foreach control
	-- if control.selected and control.enablekeyboard then
	-- control.keyPressed( key )
	-- done.
	

	
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

local number = 0

local buttonText = "Example button";

local button = GUI.Button(buttonText, Vector2(25,25), Vector2(GUI.MinTextWidth(buttonText), 25));
local input = GUI.TextInput("Input", Vector2(25,60), Vector2(125, 25))
--local inputbox = GUI.CreateComponent( "Text Input example", Vector2(25,55), Vector2(75, 25), GUI.RenderTextInput)
local pane = GUI.CreatePane("Main Pane", Vector2(65,0), Vector2(600, 400))
pane:AddComponent( button );
pane:AddComponent( input );
--pane:AddComponent( inputbox )
function love.draw()
	pane:render()
	
	if(button.status) then 
		button.name = "Pressed: " .. number;
		number = number + 1
	end
	
	
	-- Render Button
	-- GUI.RenderButton("Button X", Vector2(0, 0), Vector2(75, 25))	
	
	-- GUI.RenderButton("Another button", Vector2(80, 0), Vector2(75, 25))
	--GUI.RenderButton("Button X", Vector2(25, 25), Vector2(75, 65))	
	--GUI.RenderButton("Hello World", Vector2(45, 45), Vector2(75, 25))	
	--GUI.RenderButton("Detonate", Vector2(85, 67), Vector2(75, 25))	
end