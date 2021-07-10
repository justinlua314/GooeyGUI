goo.ProgressMeta = {
	id = "metaid",
	x = 0, y = 0, w = 0, l = 0,
	value = 0,
	color = {1, 1, 1, 1},
	progressColor = {0, 1, 0, 1}
}

goo.Progresses = {}

goo.FrameMeta.children.progresses = {}





-- Sets ====================================================================================================================

function goo.ProgressMeta:SetPos(x, y)
	self.x, self.y = x, y
end

function goo.ProgressMeta:SetSize(w, l)
	self.w, self.l = w, l
end

function goo.ProgressMeta:SetValue(int)
	if int > 100 then int = 100 end
	if int < 0 then int = 0 end
	self.value = int
end

function goo.ProgressMeta:SetColor(r, g, b, a)
	if a == nil then a = 1 end
	self.color = {r, g, b, a}
end

function goo.ProgressMeta:SetProgressColor(r, g, b, a)
	if a == nil then a = 1 end
	self.progressColor = {r, g, b, a}
end





-- Gets ====================================================================================================================

function goo.ProgressMeta:GetPos()
	return self.x, self.y
end

function goo.ProgressMeta:GetSize()
	return self.w, self.l
end

function goo.ProgressMeta:GetVal()
	return self.value
end

function goo.ProgressMeta:GetColor()
	return self.color
end

function goo.ProgressMeta:GetProgressColor()
	return self.progressColor
end





-- Actions =================================================================================================================

function goo.getProgress(id)
	if goo.Progresses[id] then return goo.Progresses[id] end

	for _,frame in pairs(goo.Frames) do
		if frame.children.progresses[id] then return frame.children.progresses[id] end
	end

	return nil
end

function goo.ProgressMeta:Finalize(id, parent)
	if id then
		if parent then
			parent.children.progresses[id] = self
		else
			goo.Progresses[id] = self
		end
	end
end

function goo.ProgressMeta:Remove()
	if goo.Progresses[self.id] then
		goo.Progresses[self.id] = nil
		return
	end

	for _,frame in pairs(goo.Frames) do
		if frame.children.progresses[self.id] then
			frame.children.progresses[self.id] = nil
			break
		end
	end
end





-- Engine ==================================================================================================================

function goo.progressDrawIndividual(progress)
	love.graphics.setColor(progress.color)
	love.graphics.rectangle("fill", progress.x, progress.y, progress.w, progress.l)

	local len = ((progress.w - 10) / 100)
	love.graphics.setColor(progress.progressColor)
	love.graphics.rectangle("fill", progress.x + 5, progress.y + 5, (len * progress.value), (progress.l - 10))
end

function goo.progressDraw()
	for _,progress in pairs(goo.Progresses) do
		goo.progressDrawIndividual(progress)
	end
end

goo.addElement("GProgress",
	goo.ProgressMeta,
	goo.Progresses,
	goo.progressDraw,
	goo.progressDrawIndividual)
