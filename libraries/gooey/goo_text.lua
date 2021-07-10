goo.TextMeta = {
	id = "metaid",
	x = 0, y = 0, w = 200,
	value = "",
	font = nil,
	color = {1, 1, 1, 1}
}

goo.Texts = {}

goo.FrameMeta.children.texts = {}





-- Sets ====================================================================================================================

function goo.TextMeta:SetPos(x, y)
	self.x, self.y = x, y
end

function goo.TextMeta:SetWidth(w)
	self.w = w
end

function goo.TextMeta:SetColor(r, g, b, a)
	if a == nil then a = 1 end
	self.color = {r, g, b, a}
end

function goo.TextMeta:SetText(txt)
	self.value = txt
end

function goo.TextMeta:SetFont(font)
	self.font = font
end





-- Gets ====================================================================================================================

function goo.TextMeta:GetPos()
	return self.x, self.y
end

function goo.TextMeta:GetWidth()
	return self.w
end

function goo.TextMeta:GetColor()
	return self.color
end

function goo.TextMeta:GetText()
	return self.value
end

function goo.TextMeta:GetFont()
	return self.font
end





-- ACTIONS =====================================================

function goo.getText(id)
	if goo.Texts[id] then return goo.Texts[id] end

	for _,frame in pairs(goo.Frames) do
		if frame.children.texts[id] then return frame.children.texts[id] end
	end

	return nil
end

function goo.TextMeta:Finalize(id, parent)
	if id then
		if parent then
			parent.children.texts[id] = self
		else
			goo.Texts[id] = self
		end
	end
end

function goo.TextMeta:Remove()
	if goo.Texts[self.id] then
		goo.Texts[self.id] = nil
		return
	end

	for _,frame in pairs(goo.Frames) do
		if frame.children.texts[self.id] then
			frame.children.texts[self.id] = nil
			break
		end
	end
end





-- ENGINE ======================================================

function goo.textDrawIndividual(text)
	local currentFont = nil
	love.graphics.setColor(text.color)

	if text.font then
		currentFont = love.graphics.getFont()
		love.graphics.setFont(text.font)
	end

	love.graphics.printf(text.value, text.x, text.y, text.w)
	if currentFont ~= nil then love.graphics.setFont(currentFont) end
end

function goo.textDraw()
	for _,text in pairs(goo.Texts) do
		goo.btextDrawIndividual(text)
	end
end

goo.addElement("GText",
	goo.TextMeta,
	goo.Texts,
	goo.textDraw,
	goo.textDrawIndividual)
