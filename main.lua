
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
-- cant remember why i tried to use this... might be to avoid control chars being put in text boxes.
function love.textinput(t)
	--commandText = commandText .. t
	
	
	for k, v in pairs(GUI.Components) do
		if( v.enableKeyboard == true and v.KeyPressed ~= nil) then
			v.KeyPressed( t )
		end	
	end
end


function love.keypressed(t)
	if( t == "backspace" ) then
		love.textinput(t); -- allow this char through.
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

local number = 0

local buttonText = "Press me";
local labelText = "Example label:";
local labelWidth = GUI.MinTextWidth(labelText);

---
--- Button
--- This additionally has a label on the left side of it.
local buttonLabelText = "Example button: ";
local buttonLabel = GUI.Label(buttonLabelText, Vector2(25,25), Vector2(GUI.MinTextWidth(buttonLabelText),25))

local button = GUI.Button(buttonText, Vector2(buttonLabel.pos.x + buttonLabel.size.x,25), Vector2(GUI.MinTextWidth(buttonText), 25));


-- Label and Input box.
local input = GUI.TextInput("Input", Vector2(labelWidth + 25,60), Vector2(125, 25))
local label = GUI.Label(labelText, Vector2(25, 60), Vector2(labelWidth, 25))
local image = GUI.Image("Picture", Vector2(25, 150), "imageExample.png", Vector2(0.25, 0.25));


local submitText = "Submit"
local exampleSubmit = GUI.Button(submitText, Vector2(input.pos.x + input.size.x, input.pos.y), Vector2(GUI.MinTextWidth(submitText),25));
exampleSubmit.buttonStateChanged = function ( state  )
	if( state == true and input.value ~= "" ) then
		print("Data submitted: [ ".. input.value .. " ]");
		input.value = "";
	end	
end
--local inputbox = GUI.CreateComponent( "Text Input example", Vector2(25,55), Vector2(75, 25), GUI.RenderTextInput)
local pane = GUI.CreatePane("Main Pane", Vector2(65,0), Vector2(600, 400))
pane:AddComponent( button );
pane:AddComponent( buttonLabel );
pane:AddComponent( input );
pane:AddComponent( label );
pane:AddComponent( image );
pane:AddComponent( exampleSubmit );
--pane:AddComponent( inputbox )
function love.draw()
	pane:render()
	
	if(button.status) then 
		button.name = "Pressed: " .. number;
		number = number + 1
		
		-- Automatically adjust width of the button so that it automatically expands.
		button.size.x = GUI.MinTextWidth( button.name );
	end
	
	
	-- Render Button
	-- GUI.RenderButton("Button X", Vector2(0, 0), Vector2(75, 25))	
	
	-- GUI.RenderButton("Another button", Vector2(80, 0), Vector2(75, 25))
	--GUI.RenderButton("Button X", Vector2(25, 25), Vector2(75, 65))	
	--GUI.RenderButton("Hello World", Vector2(45, 45), Vector2(75, 25))	
	--GUI.RenderButton("Detonate", Vector2(85, 67), Vector2(75, 25))	
end