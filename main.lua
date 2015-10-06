
-- optimize: add event so that the objects and mouse position are only checked when they change instead of each tick.


local utf8 = require("utf8")
local rectF = love.graphics.rectangle
local mouseImagePath = "Data/cursor.png"

local vector2 = require("vector2")

--
-- GUI ELEMENTS
--

local GUI = require("gui");
GUI.TextInput = require("UIElements.TextInput");
GUI.Image = require("UIElements.Image");
GUI.Label = require("UIElements.Label");
GUI.Button = require("UIElements.Button");
GUI.ListBox = require("UIElements.ListBox");

--
-- END GUI ELEMENTS.
--


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

-- Submit example
local submitText = "Submit"
local exampleSubmit = GUI.Button(submitText, Vector2(input.pos.x + input.size.x, input.pos.y), Vector2(GUI.MinTextWidth(submitText),25));
exampleSubmit.buttonStateChanged = function ( state )
	if( state == true and input.value ~= "" ) then
		print("Data submitted: [ ".. input.value .. " ]");
		input.value = "";
	end	
end

-- Main pane for the GUI system.
local pane = GUI.CreatePane("Main Pane", Vector2(65,0), Vector2(600, 400))
pane:AddComponent( button );
pane:AddComponent( buttonLabel );
pane:AddComponent( input );
pane:AddComponent( label );
pane:AddComponent( image );
pane:AddComponent( exampleSubmit );

-- Exit button
local exitAppLabel = "Exit test"
local exitApplication = GUI.Button(exitAppLabel, Vector2(pane.size.x - GUI.MinTextWidth(exitAppLabel) - 10,10), Vector2(GUI.MinTextWidth(exitAppLabel), 25))
exitApplication.buttonStateChanged = function ( state )
	print("Shutting down...");
	love.event.quit();
end
pane:AddComponent( exitApplication );

-- ListBox
local testListBox = GUI.ListBox("listbox example", Vector2(25,300), Vector2(125,25), {"File", "Open", "Delete"});

pane:AddComponent( testListBox );


-- Love2D Draw function.
function love.draw()
	pane:render()
	
	if(button.status) then 
		button.name = "Pressed: " .. number;
		number = number + 1
		
		-- Automatically adjust width of the button so that it automatically expands.
		button.size.x = GUI.MinTextWidth( button.name );
	end
end