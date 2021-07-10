goo.ButtonMeta = {
	id = "metaid",
	x = 0, y = 0, w = 0, l = 0,
	text = {value = "", x = 0, y = 0},
	font = nil,
	color = {1, 1, 1, 1},
	onHoverColor = {0.78, 0.78, 0.78, 1},
	textColor = {0, 0, 0, 1},
	onHoverTextColor = {0, 0, 0, 1},
	onHoverSound = nil,
	hoverVolume = 0.1,
	DoClick = function() end,
	DoRightClick = function() end,

	-- internal
	isHovering = false
}

goo.Buttons = {}
goo.ButtonLeftClick = nil
goo.ButtonRightClick = nil

goo.FrameMeta.children.buttons = {}





-- Sets ====================================================================================================================

function goo.ButtonMeta:SetSize(w, l)
	self.w, self.l = w, l
end

function goo.ButtonMeta:SetPos(x, y)
	self.x, self.y = x, y
end

function goo.ButtonMeta:SetColor(r, g, b, a)
	if a == nil then a = 1 end
	self.color = {r, g, b, a}
end

function goo.ButtonMeta:SetOnHoverColor(r, g, b, a)
	if a == nil then a = 1 end
	self.onHoverColor = {r, g, b, a}
end

function goo.ButtonMeta:SetTextColor(r, g, b, a)
	if a == nil then a = 1 end
	self.textColor = {r, g, b, a}
end

function goo.ButtonMeta:SetOnHoverTextColor(r, g, b, a)
	if a == nil then a = 1 end
	self.onHoverTextColor = {r, g, b, a}
end

function goo.ButtonMeta:SetText(str)
	self.text.value = str
end

function goo.ButtonMeta:SetFont(font)
	self.font = font
end

function goo.ButtonMeta:SetHoverSound(sound)
	self.onHoverSound = sound
end

function goo.ButtonMeta:SetVolume(int)
	self.hoverVolume = int
end





-- GETS ====================================================================================================================

function goo.ButtonMeta:GetSize()
	return self.w, self.l
end

function goo.ButtonMeta:GetPos(x, y)
	return self.x, self.y
end

function goo.ButtonMeta:GetColor(r, g, b, a)
	return self.color
end

function goo.ButtonMeta:GetOnHoverColor(r, g, b, a)
	return self.onHoverColor
end

function goo.ButtonMeta:GetTextColor(r, g, b, a)
	return self.textColor
end

function goo.ButtonMeta:GetOnHoverTextColor(r, g, b, a)
	return self.onHoverTextColor
end

function goo.ButtonMeta:GetText(str)
	return self.text.value
end

function goo.ButtonMeta:GetFont()
	return self.font
end

function goo.ButtonMeta:GetHoverSound()
	return self.onHoverSound
end

function goo.ButtonMeta:GetVolume()
	return self.volume
end





-- Actions =================================================================================================================

function goo.ButtonMeta:CenterText()
	self.text.x = math.floor((self.w / 2) - (goo.getTextWidth(self.text.value) / 2))
	self.text.y = math.floor((self.l / 2) - (goo.getTextHeight(self.text.value) / 2))
end

function goo.ButtonMeta:AlignHorizontal(alignment)
	if alignment == "left" then
		self.text.x = 3
	elseif alignment == "center" then
		self.text.x = math.floor((self.w / 2) - (goo.getTextWidth(self.text.value) / 2))
	elseif alignment == "right" then
		self.text.x = math.floor(self.w - goo.getTextWidth(self.text.value) - 3)
	end
end

function goo.ButtonMeta:AlignVertical(alignment)
	if alignment == "top" then
		self.text.y = 3
	elseif alignment == "center" then
		self.text.y = math.floor((self.l / 2) - (goo.getTextHeight(self.text.value) / 2))
	elseif alignment == "bottom" then
		self.text.y = math.floor(self.l - goo.getTextHeight(self.text.value) - 3)
	end
end

function goo.getButton(id)
	if goo.Buttons[id] then return goo.Buttons[id] end

	for _,frame in pairs(goo.Frames) do
		if frame.children.buttons[id] then return fame.children.buttons[id] end
	end

	return nil
end

function goo.ButtonMeta:Finalize(id, parent)
	if id then
		self.id = id
		if parent then
			parent.children.buttons[id] = self
		else
			goo.Buttons[id] = self
		end
	end
end

function goo.ButtonMeta:Remove()
	if goo.Buttons[self.id] then
		goo.Buttons[self.id] = nil
		return
	end

	for _,frame in pairs(goo.Frames) do
		if frame.children.buttons[self.id] then
			frame.children.buttons[self.id] = nil
			break
		end
	end
end





-- Engine ==================================================================================================================

function goo.buttonDrawIndividual(button)
	if button.isHovering == true then
		love.graphics.setColor(button.onHoverColor)
	else
		love.graphics.setColor(button.color)
	end

	love.graphics.rectangle("fill", button.x, button.y, button.w, button.l)

	if button.text ~= nil then
		if button.isHovering == true then
			love.graphics.setColor(button.onHoverTextColor)
		else
			love.graphics.setColor(button.textColor)
		end

		local currentFont = nil
		if button.font then
			currentFont = love.graphics.getFont()
			love.graphics.setFont(button.font)
		end

		love.graphics.print(button.text.value, button.x + button.text.x, button.y + button.text.y)
		if currentFont ~= nil then love.graphics.setFont(currentFont) end
	end
end

function goo.buttonDraw()
	for _,button in pairs(goo.Buttons) do
		goo.buttonDrawIndividual(button)
	end
end

function goo.buttonMousePressed(x, y, b)
	local gotbutton = nil
	for _,button in pairs(goo.Buttons) do
		if goo.getIntersect(x, y, button.x, button.y, button.w, button.l) == true then
			gotbutton = button
		end
	end

	local topFrame = nil

	for _,id in pairs(goo.frameDrawOrder) do
		if goo.Frames[id] then
			topFrame = goo.Frames[id]
		end
	end

	if topFrame then
		for _,button in pairs(topFrame.children.buttons) do
			if goo.getIntersect(x, y, button.x, button.y, button.w, button.l) == true then
				gotbutton = button
			end
		end
	end

	if gotbutton then
		if b == 1 then
			goo.ButtonLeftClick = gotbutton
		elseif b == 2 then
			goo.ButtonRightClick = gotbutton
		end
	end
end

function goo.buttonMouseReleased(x, y, b)
	local button = nil
	if b == 1 and goo.ButtonLeftClick then
		button = goo.ButtonLeftClick
		if goo.getIntersect(x, y, button.x, button.y, button.w, button.l) == true then
			goo.ButtonLeftClick = nil
			button.DoClick()
		end
	elseif b == 2 and goo.ButtonRightClick then
		button = goo.ButtonRightClick
		if goo.getIntersect(x, y, button.x, button.y, button.w, button.l) == true then
			goo.ButtonRightClick = nil
			button.DoClick()
		end
	end
end

function goo.buttonMouseMoved(x, y, dx, dy)
	for _,button in pairs(goo.Buttons) do
		if button.onHoverColor then
			if goo.getIntersect(x, y, button.x, button.y, button.w, button.l) == true then
				if button.isHovering == false then
					button.isHovering = true
					if button.onHoverSound then
						local s = love.audio.newSource(button.onHoverSound)
						s:SetVolume(hoverVolume)
						s:play()
					end
				end
			else
				button.isHovering = false
			end
		end
	end

	for _,frame in pairs(goo.Frames) do
		for _,button in pairs(frame.children.buttons) do
			if button.onHoverColor then
				if goo.getIntersect(x,y, button.x, button.y, button.w, button.l) == true then 
					if button.isHovering == false then
						button.isHovering = true
						if button.onHoverSound then
							local s = love.audio.newSource(button.onHoverSound)
							s:SetVolume(hoverVolume)
							s:play()
						end
					end
				else
					button.isHovering = false
				end
			end
		end
	end
end

goo.addElement("GButton",
	goo.ButtonMeta,
	goo.Buttons,
	goo.buttonDraw,
	goo.buttonDrawIndividual,
	goo.buttonMousePressed,
	goo.buttonMouseReleased,
	goo.buttonMouseMoved)
