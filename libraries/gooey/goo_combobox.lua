goo.ComboBoxMeta = {
	id = "metaid",
	x = 0, y = 0, w = 0, l = 0,
	color = {1, 1, 1, 1},
	borderColor = {0, 0, 0, 1},
	textColor = {0, 0, 0, 1},
	selected = 0,
	text = {value = "", x = 2, y = 0},
	font = nil,
	choices = {},
	onSelect = function(intValue, textValue) end,
	alignment = {horizontal = "left", vertical = "center"},

	-- internal
	isOpen = false,
	preptoclick = false,
	preptoselect = false
}

goo.ComboBoxes = {}

goo.FrameMeta.children.comboboxes = {}





-- Sets ====================================================================================================================

function goo.ComboBoxMeta:SetPos(x, y)
	self.x, self.y = x, y
end

function goo.ComboBoxMeta:SetSize(w, l)
	self.w, self.l = w, l
end

function goo.ComboBoxMeta:SetColor(r, g, b, a)
	if a == nil then a = 1 end
	self.color = {r, g, b, a}
end

function goo.ComboBoxMeta:SetTextColor(r, g, b, a)
	if a == nil then a = 1 end
	self.textColor = {r, g, b, a}
end

function goo.ComboBoxMeta:SetChoices(t)
	self.choices = t
end

function goo.ComboBoxMeta:SetFont(font)
	self.font = font
end





-- Gets ====================================================================================================================

function goo.ComboBoxMeta:GetSize()
	return self.w, self.l
end

function goo.ComboBoxMeta:GetPos()
	return self.x, self.y
end

function goo.ComboBoxMeta:GetColor()
	return self.color
end

function goo.ComboBoxMeta:GetTextColor()
	return self.textColor
end

function goo.ComboBoxMeta:GetChoices()
	return self.choices
end

function goo.ComboBoxMeta:GetFont()
	return self.font
end

function goo.ComboBoxMeta:GetSelectedID()
	return self.selected
end

function goo.ComboBoxMeta:GetOption()
	return self.text.value
end

function goo.ComboBoxMeta:GetAlignment()
	return self.alignment
end





-- Actions =================================================================================================================

function goo.ComboBoxMeta:AddChoice(choice)
	table.insert(self.choices, choice)
end

function goo.ComboBoxMeta:ChooseOption(option)
	for id,choice in pairs(self.choices) do
		if choice == option then
			self.selected = id
		end
	end
end

function goo.ComboBoxMeta:ChooseOptionID(id)
	self.selected = id
end

function goo.ComboBoxMeta:Clear()
	self.selected = 0
end

function goo.ComboBoxMeta:CenterText()
	self.alignment = {horizontal = "center", vertical = "center"}
end

function goo.ComboBoxMeta:AlignHorizontalText(alignment)
	self.alignment.horizontal = alignment
end

function goo.ComboBoxMeta:AlignVerticalText(alignment)
	self.alignment.vertical = alignment
end

function goo.getComboBox(id)
	if goo.ComboBoxes[id] then return goo.ComboBoxes[id] end

	for _,frame in pairs(goo.Frames) do
		if frame.children.comboboxes[id] then return frame.children.comboboxes[id] end
	end

	return nil
end

function goo.ComboBoxMeta:Finalize(id, parent)
	if id then
		self.id = id
		if parent then
			parent.children.comboboxes[id] = self
		else
			goo.ComboBoxes[id] = self
		end
	end
end

function goo.ComboBoxMeta:Remove()
	if goo.ComboBoxes[self.id] then
		goo.ComboBoxes[self.id] = nil
		return
	end

	for _,frame in pairs(goo.Frames) do
		if frame.children.comboboxes[self.id] then
			frame.children.comboboxes[self.id] = nil
			break
		end
	end
end





-- Engine ==================================================================================================================

function goo.comboboxDrawIndividual(combobox)
	love.graphics.setColor(combobox.color)
	love.graphics.rectangle("fill", combobox.x, combobox.y, combobox.w, combobox.l)

	love.graphics.setColor(combobox.borderColor)
	love.graphics.rectangle("line", combobox.x, combobox.y, combobox.w, combobox.l)

	love.graphics.setColor(combobox.textColor)

	local currentFont = nil
	if combobox.font then
		currentFont = love.graphics.getFont()
		love.graphics.setFont(combobox.font)
	end

	local moveHorizontal, moveVertical = 3, 3

	if combobox.alignment.horizontal == "center" then
		moveHorizontal = math.floor((combobox.w / 2) - (goo.getTextWidth(combobox.text.value) / 2))
	elseif combobox.alignment.horizontal == "right" then
		moveHorizontal = math.floor(combobox.w - goo.getTextWidth(combobox.text.value) - 3)
	end

	if combobox.alignment.vertical == "center" then
		moveVertical = math.floor((combobox.l / 2) - (goo.getTextHeight(combobox.text.value) / 2))
	elseif combobox.alignment.vertical == "bottom" then
		moveVertical = math.floor(combobox.l - goo.getTextHeight(combobox.text.value) - 3)
	end

	love.graphics.print(combobox.text.value, combobox.x + moveHorizontal, combobox.y + moveVertical)

	if combobox.alignment.horizontal == "right" then
		love.graphics.print("v", combobox.x + 5, combobox.y + (combobox.l / 2) - 6)
	else
		love.graphics.print("v", combobox.x + (combobox.w - 10), combobox.y + (combobox.l / 2) - 6)
	end

	if combobox.isOpen == true then
		for boxNumber,choice in pairs(combobox.choices) do
			love.graphics.setColor(combobox.color)
			love.graphics.rectangle("fill", combobox.x, combobox.y + (combobox.l * boxNumber), combobox.w, combobox.l)

			love.graphics.setColor(combobox.borderColor)
			love.graphics.rectangle("line", combobox.x, combobox.y + (combobox.l * boxNumber), combobox.w, combobox.l)

			love.graphics.setColor(combobox.textColor)

			moveHorizontal, moveVertical = 3, 3
			if combobox.alignment.horizontal == "center" then
				moveHorizontal = math.floor((combobox.w / 2) - (goo.getTextWidth(choice) / 2))
			elseif combobox.alignment.horizontal == "right" then
				moveHorizontal = math.floor(combobox.w - goo.getTextWidth(choice) - 3)
			end

			if combobox.alignment.vertical == "center" then
				moveVertical = math.floor((combobox.l / 2) - (goo.getTextHeight(choice) / 2))
			elseif combobox.alignment.vertical == "bottom" then
				moveVertical = math.floor(combobox.l - goo.getTextHeight(choice) - 3)
			end

			love.graphics.print(choice, combobox.x + moveHorizontal, (combobox.y + (combobox.l * boxNumber)) + moveVertical)
		end
	end

	if currentFont then love.graphics.setFont(currentFont) end
end

function goo.comboboxDraw()
	for _,combobox in pairs(goo.ComboBoxes) do
		goo.comboboxDrawIndividual(combobox)
	end
end

function goo.comboboxMousePressed(x, y, button)
	for _,combobox in pairs(goo.ComboBoxes) do
		if goo.getIntersect(x, y, combobox.x, combobox.y, combobox.w, combobox.l) == true then
			combobox.preptoclick = true
			break
		end

		if combobox.isOpen == true then
			for boxNumber,choice in pairs(combobox.choices) do
				if bgui.getIntersect(x,y,combobox.x, combobox.y+(combobox.l*boxNumber), combobox.w, combobox.l) == true then
					combobox.preptoselect = true
				end
			end
		end
	end

	local topFrame = nil

	for _,id in pairs(goo.frameDrawOrder) do
		if goo.Frames[id] then
			topFrame = goo.Frames[id]
		end
	end

	if topFrame then
		for _,combobox in pairs(topFrame.children.comboboxes) do
			if goo.getIntersect(x, y, combobox.x, combobox.y, combobox.w, combobox.l) == true then
				combobox.preptoclick = true
				break
			end

			if combobox.isOpen == true then
				for boxNumber,choice in pairs(combobox.choices) do
					if goo.getIntersect(x,y,combobox.x,combobox.y+ (combobox.l*boxNumber),combobox.w,combobox.l)== true then
						combobox.selected = boxNumber
						combobox.text.value = choice
						combobox.onSelect(combobox.selected, combobox.text.value)
						combobox.isOpen = false
					end
				end
			end

			combobox.preptoclick = false
			combobox.preptoselect = false
		end
	end
end

function goo.comboboxMouseReleased(x, y, button)
	for _,combobox in pairs(goo.ComboBoxes) do
		if goo.getIntersect(x,y, combobox.x, combobox.y, combobox.w, combobox.l)== true and combobox.preptoclick== true then
			if combobox.isOpen == true then
				combobox.isOpen = false
			else
				combobox.isOpen = true
			end
		end

		if combobox.isOpen == true and combobox.preptoselect == true then
			for boxNumber,choice in pairs(combobox.choices) do
				if bgui.getIntersect(x,y, combobox.x, combobox.y+(combobox.l*boxNumber), combobox.w, combobox.l)== true then
					combobox.selected = boxNumber
					combobox.text.value = choice
					combobox.onSelect(combobox.selected, combobox.text.value)
					combobox.isOpen = false
				end
			end
		end

		combobox.preptoclick = false
		combobox.preptoselect = false
	end

	local topFrame = nil

	for _,id in pairs(goo.frameDrawOrder) do
		if goo.Frames[id] then
			topFrame = goo.Frames[id]
		end
	end

	if topFrame then
		for _,combobox in pairs(topFrame.children.comboboxes) do
			if goo.getIntersect(x,y,combobox.x,combobox.y,combobox.w,combobox.l)== true and combobox.preptoclick== true then
				if combobox.isOpen == true then
					combobox.isOpen = false
				else
					combobox.isOpen = true
				end
			end

			if combobox.isOpen == true and combobox.preptoselect == true then
				for boxNumber,choice in pairs(combobox.choices) do
					if bgui.getIntersect(x,y, combobox.x, combobox.y + (combobox.l * k), combobox.w, combobox.l)== true then
						combobox.selected = boxNumber
						combobox.text.value = choice
						combobox.onSelect(combobox.selected, combobox.text.value)
						combobox.isOpen = false
					end
				end
			end

			combobox.preptoclick = false
			combobox.preptoselect = false
		end
	end
end

goo.addElement("GComboBox",
	goo.ComboBoxMeta,
	goo.ComboBoxes,
	goo.comboboxDraw,
	goo.comboboxDrawIndividual,
	goo.comboboxMousePressed,
	goo.comboboxMouseReleased,
	nil)
