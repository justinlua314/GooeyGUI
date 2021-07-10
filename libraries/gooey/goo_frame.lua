goo.FrameMeta = {
	id = "metaid",
	x = 0, y = 0, w = 0, l = 0,
	headerLength = 20,
	headerColor = {0.471, 0.482, 0.49, 1}, bodyColor = {0.42, 0.435, 0.443, 1},
	title = "Window", titleColor = {1, 1, 1, 1},
	font = nil, draggable = false,
	showClose = true,
	onClose = function() end,
	children = {},

	-- internal
	preptoclose = false
}

goo.Frames = {}
goo.frameDrawOrder = {}





-- Sets ====================================================================================================================

function goo.FrameMeta:SetPos(x, y)
	self.x, self.y = x, y
end

function goo.FrameMeta:SetSize(w, l)
	self.w, self.l = w, l
end

function goo.FrameMeta:SetHeaderColor(r, g, b, a)
	if a == nil then a = 1 end
	self.headerColor = {r, g, b, a}
end

function goo.FrameMeta:SetBodyColor(r, g, b, a)
	if a == nil then a = 1 end
	self.bodyColor = {r, g, b, a}
end

function goo.FrameMeta:SetTitleColor(r, g, b, a)
	if a == nil then a = 1 end
	self.titleColor = {r, g, b, a}
end

function goo.FrameMeta:SetTitle(text)
	self.title = text
end

function goo.FrameMeta:SetFont(font)
	self.font = font
end

function goo.FrameMeta:SetDraggable(bool)
	self.draggable = bool
end

function goo.FrameMeta:SetShowClose(bool)
	self.showClose = bool
end





-- Gets ====================================================================================================================

function goo.FrameMeta:GetPos()
	return self.x, self.y
end

function goo.FrameMeta:GetSize()
	return self.w, self.l
end

function goo.FrameMeta:GetHeaderColor()
	return self.headerColor
end

function goo.FrameMeta:GetBodyColor()
	return self.color
end

function goo.FrameMeta:GetTitleColor()
	return self.titleColor
end

function goo.FrameMeta:GetTitle()
	return self.title
end

function goo.FrameMeta:GetFont()
	return self.font
end

function goo.FrameMeta:GetDraggable()
	return self.draggable
end

function goo.FrameMeta:GetShowClose()
	return self.showClose
end





-- Actions =================================================================================================================

function goo.getFrame(id)
	if goo.Frames[id] then return goo.Frames[id] end
	return nil
end

function goo.FrameMeta:Finalize(id)
	if id then
		self.id = id
		goo.Frames[id] = self
		table.insert(goo.frameDrawOrder, id)
	end
end

function goo.FrameMeta:Close()
	if goo.Frames[self.id] then
		self.onClose()

		for position,id in pairs(goo.frameDrawOrder) do
			if id == self.id then
				table.remove(goo.frameDrawOrder, position)
				break
			end
		end

		goo.Frames[self.id] = nil
	end
end





-- Engine ==================================================================================================================

function goo.frameDrawIndividual(frame)
	love.graphics.setColor(frame.bodyColor)
	love.graphics.rectangle("fill", frame.x, frame.y, frame.w, frame.l)

	love.graphics.setColor(frame.headerColor)
	love.graphics.rectangle("fill", frame.x, frame.y, frame.w, frame.headerLength)

	love.graphics.setColor(frame.titleColor)

	local currentFont = love.graphics.getFont()

	if frame.font then
		love.graphics.setFont(font)
	end

	love.graphics.print(frame.title, frame.x + 10, frame.y + 5)
	love.graphics.setFont(currentFont)

	if frame.showClose == true then
		if frame.preptoclose == false then
			love.graphics.setColor(255, 0, 0)
		else
			love.graphics.setColor(200, 0, 0)
		end

		love.graphics.rectangle("fill", frame.x + (frame.w - 35), frame.y + 5, 20, 10)
	end
end

function goo.frameDraw()
	for _,id in pairs(goo.frameDrawOrder) do
		if goo.Frames[id] then
			goo.frameDrawIndividual(goo.Frames[id])

			for _,child in pairs(goo.Frames[id].children) do
				for _,element in pairs(child) do
					if type(element) == "table" then
						goo.elements[element.type].drawFunc(element)
					end
				end
			end
		end
	end
end

function goo.frameMousePressed(x, y, button)
	if button == 1 then
		local frameSelected = nil
		local framenum = 0
		local gotframe = nil
		local gotclose = nil

		for position,frameid in pairs(goo.frameDrawOrder) do
			local frame = goo.Frames[frameid]
			if goo.getIntersect(x, y, frame.x, frame.y, frame.w, frame.l) == true then
				frameSelected = frameid
				framenum = position
			end

			if goo.getIntersect(x, y, frame.x, frame.y, frame.w, 20) == true then
				gotframe = frame
			end

			if frame.showClose == true and
			goo.getIntersect(x, y, frame.x + (frame.w - 35), frame.y + 5, 20, 10) == true then
				gotclose = frame
			end
		end

		if frameSelected then		
			table.remove(goo.frameDrawOrder, framenum)
			table.insert(goo.frameDrawOrder, frameSelected)
		end

		if gotframe and gotframe.id == frameSelected and gotframe:GetDraggable() == true then
			gotframe.dragging = true
			gotframe.mouseOffsetX = (love.mouse.getX() - gotframe.x)
			gotframe.mouseOffsetY = (love.mouse.getY() - gotframe.y)
		end

		if gotclose then gotclose.preptoclose = true end
	end
end

function goo.frameMouseReleased(x, y, button)
	if button == 1 then
		for _,frame in pairs(goo.Frames) do
			if frame.dragging == true then
				frame.dragging = false
			end

			if frame.preptoclose == true and
			goo.getIntersect(x, y, frame.x + (frame.w - 35), frame.y + 5, 20, 10) == true then
				frame:Close()
			end
			frame.preptoclose = false
		end
	end
end

function goo.frameMouseMoved(x, y, dx, dy)
	for _,frame in pairs(goo.Frames) do
		if frame.dragging == true and frame.preptoclose == false then
			frame.x = (frame.x + dx)
			frame.y = (frame.y + dy)

			for _,children in pairs(frame.children) do
				if type(children) == "table" then
					for _,element in pairs(children) do
						element.x = (element.x + dx)
						element.y = (element.y + dy)
						if element.cursorX then element.cursorX = (element.cursorX + dx) end
					end
				end
			end
			break
		end
	end
end




goo.addElement("GFrame",
	goo.FrameMeta,
	goo.Frames,
	goo.frameDraw,
	function() end,
	goo.frameMousePressed,
	goo.frameMouseReleased,
	goo.frameMouseMoved)
