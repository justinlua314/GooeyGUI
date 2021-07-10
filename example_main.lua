require("libraries/gooey/goo_core")

function love.load()
	local f = goo.create("GFrame")
	f:SetPos(100, 100)
	f:SetSize(400, 250)
	f:SetTitle("Demonstration")
	f:SetDraggable(true)
	f:Finalize("DemoFrame")

	local t = goo.create("GText")
	t:SetText("This is a demonstration of the gooey GUI library")
	t:SetPos(110, 130)
	t:SetWidth(380)
	t:Finalize("headerText", f)

	local sliderValue = goo.create("GText")
	sliderValue:SetText("1")
	sliderValue:SetPos(110, 160)
	sliderValue:Finalize("sliderValueText", f)

	local slider = goo.create("GNumslider")
	slider:SetPos(140, 165)
	slider:SetSize(320)
	slider:SetMin(1)
	slider:SetMax(50)
	slider:SetColor(255, 0, 0)
	slider:SetValue(1)
	slider.onValueChanged = function(val)
		goo.getText("sliderValueText"):SetText(tostring(val))
		goo.getProgress("progressDemo"):SetValue(val * 2)
	end
	slider:Finalize("sliderOne", f)

	local progress = goo.create("GProgress")
	progress:SetPos(140, 180)
	progress:SetSize(320, 20)
	progress:SetValue(2)
	progress:SetColor(125, 125, 125)
	progress:SetProgressColor(0, 255, 0)
	progress:Finalize("progressDemo", f)

	local textentry = goo.create("GTextEntry")
	textentry:SetPos(140, 220)
	textentry:SetSize(160, 20)
	textentry:SetValue("Type here")
	textentry:SetTextColor(0, 0, 255)
	textentry.onSelect = function()
		if goo.getTextEntry("textEntryDemo"):GetValue() == "Type here" then
			goo.getTextEntry("textEntryDemo"):Clear()
		end
	end

	textentry.onEnter = function()
		goo.getTextEntry("textEntryDemo").editing = false
		print(goo.getTextEntry("textEntryDemo"):GetValue())
		goo.getTextEntry("textEntryDemo"):Clear()
	end
	textentry:Finalize("textEntryDemo", f)

	local button = goo.create("GButton")
	button:SetPos(320, 220)
	button:SetSize(50, 20)
	button:SetText("Example")
	button.DoClick = function()
		goo.getFrame("DemoFrame"):SetTitle(tostring(math.random(1000, 9999)))
	end
	button:Finalize("exampleButton", f)

	local combobox = goo.create("GComboBox")
	combobox:SetPos(140, 260)
	combobox:SetSize(320, 20)
	combobox:SetChoices({"Choice 1", "Choice 2", "Choice 3"})
	combobox:Finalize("choices", f)
end

function love.update(dt)
end

function love.draw()
	goo.draw()
end

function love.keypressed(key, unicode)
	goo.keypressed(key)
end

function love.textinput(text)
	goo.textInput(text)
end

function love.mousepressed(x, y, button)
	goo.mousePressed(x, y, button)
end

function love.mousereleased(x, y, button)
	goo.mouseReleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
	goo.mouseMoved(x, y, dx, dy)
end
