goo.TextEntryMeta = {
    id = "metaid",
    x = 0, y = 0, w = 0, l = 0,
    value = "",
    font = nil,
    color = {1, 1, 1, 1},
    selectedColor = {0.784, 0.784, 0.784, 1},
    textColor = {0, 0, 0, 1},
    cursorColor = {0, 0, 0, 1},
    onEnter = function() end,
    onTab = function() end,
    onSelect = function() end,
    editable = true,
    alignment = {horizontal = "left", vertical = "center"},

    --internal
    editing = false,
    cx, dist = 0, 0
}

goo.TextEntries = {}

goo.FrameMeta.children.textentries = {}





-- Sets ====================================================================================================================

function goo.TextEntryMeta:SetPos(x, y)
    self.x, self.y = x, y
    self.cx = x + 3
end

function goo.TextEntryMeta:SetSize(w, l)
    self.w, self.l = w, l
end

function goo.TextEntryMeta:SetValue(txt)
    self.value, self.dist = "", 0
    for i = 0, string.len(txt) do
        self.value = (self.value .. string.sub(txt, i, i))

        if (goo.getTextWidth(string.sub(self.value, (self.dist + 1),
            string.len(self.value))) + goo.getTextWidth(string.sub(txt, i, i))) > self.w then
            self.dist = (self.dist + 1)
        end

        self.cx = (self.x + goo.getTextWidth(string.sub(self.value, (self.dist + 1), string.len(self.value))) + 3)
    end
end

function goo.TextEntryMeta:SetFont(font)
    self.font = font
end

function goo.TextEntryMeta:SetColor(r, g, b, a)
    if a == nil then a = 1 end
    self.color = {r, g, b, a}
end

function goo.TextEntryMeta:SetEditingColor(r, g, b, a)
    if a == nil then a = 1 end
    self.selectedColor = {r, g, b, a}
end

function goo.TextEntryMeta:SetTextColor(r, g, b, a)
    if a == nil then a = 1 end
    self.textColor = {r, g, b, a}
end

function goo.TextEntryMeta:SetCursorColor(r, g, b, a)
    if a == nil then a = 1 end
    self.cursorColor = {r, g, b, a}
end





-- Gets ====================================================================================================================

function goo.TextEntryMeta:GetPos()
    return self.x, self.y
end

function goo.TextEntryMeta:GetSize()
    return self.w, self.l
end

function goo.TextEntryMeta:GetValue()
    return self.value
end

function goo.TextEntryMeta:GetFont()
    return self.font
end

function goo.TextEntryMeta:GetColor()
    return self.color
end

function goo.TextEntryMeta:GetEditingColor()
    return self.selectedColor
end

function goo.TextEntryMeta:GetTextColor()
    return self.textColor
end

function goo.TextEntryMeta:GetCursorColor()
    return self.cursorColor
end

function goo.ComboBoxMeta:GetAlignment()
    return self.alignment
end





-- Actions =================================================================================================================

function goo.TextEntryMeta:Clear()
    self:SetValue("")
end

function goo.TextEntryMeta:CenterText()
    self.alignment = {horizontal = "center", vertical = "center"}
end

function goo.TextEntryMeta:AlignHorizontalText(alignment)
    self.alignment.horizontal = alignment
end

function goo.TextEntryMeta:AlignVerticalText(alignment)
    self.alignment.vertical = alignment
end

function goo.getTextEntry(id)
    if goo.TextEntries[id] then return goo.TextEntries[id] end

    for _,frame in pairs(goo.Frames) do
        if frame.children.textentries[id] then return frame.children.textentries[id] end
    end
end

function goo.TextEntryMeta:Finalize(id, parent)
    if id then
        if parent then
            parent.children.textentries[id] = self
        else
            goo.TextEntries[id] = self
        end
    end
end

function goo.TextEntryMeta:Remove()
    if goo.TextEntries[self.id] then
        goo.TextEntries[self.id] = nil
        return
    end

    for _,frame in pairs(goo.Frames) do
        if frame.children.textentries[self.id] then
            frame.children.textentries[self.id] = nil
            break
        end
    end
end





-- Engine ==================================================================================================================

function goo.textentryDrawIndividual(textentry)
    local currentFont = nil
    if textentry.editing == true then
        love.graphics.setColor(textentry.selectedColor)
    else
        love.graphics.setColor(textentry.color)
    end
    love.graphics.rectangle("fill", textentry.x, textentry.y, textentry.w, textentry.l)

    love.graphics.setColor(textentry.textColor)

    if textentry.font then
        currentFont = love.graphics.getFont()
        love.graphics.setFont(textentry.font)
    end

    local moveHorizontal, moveVertical = 3, 3

    if textentry.alignment.horizontal == "center" then
        moveHorizontal = math.floor((textentry.w / 2) - (goo.getTextWidth(textentry) / 2))
    elseif textentry.alignment.horizontal == "right" then
        moveHorizontal = math.floor(textentry.w - goo.getTextWidth(textentry.value) - 3)
    end

    if textentry.alignment.vertical == "center" then
        moveVertical = math.floor((textentry.l / 2) - (goo.getTextHeight(textentry.value) / 2))
    elseif textentry.alignment.vertical == "bottom" then
        moveVertical = math.floor(textentry.l - goo.getTextHeight(textentry.value) - 3)
    end

    love.graphics.print(string.sub(textentry.value, (textentry.dist + 1),
        string.len(textentry.value)), textentry.x + moveHorizontal, textentry.y + moveVertical)

    if currentFont then love.graphics.setFont(currentFont) end

    if textentry.editing == true then
        love.graphics.setColor(textentry.cursorColor)
        love.graphics.line(textentry.cx, textentry.y + 2, textentry.cx, (textentry.y + textentry.l) - 4)
    end
end

function goo.textentryDraw()
    for _,textentry in pairs(goo.TextEntries) do
        goo.textentryDrawIndividual(textentry)
    end
end

function goo.textentryMousePressed(x, y, button)
    local found = false
    for _,textentry in pairs(goo.TextEntries) do
        if goo.getIntersect(x,y,textentry.x,textentry.y, textentry.w, textentry.l)== true and textentry.editable== true then
            textentry.editing = true
            textentry.onSelect()
            found = true
        else
            textentry.editing = false
        end
    end

    local topFrame = nil

    for _,id in pairs(goo.frameDrawOrder) do
        if goo.Frames[id] then
            topFrame = goo.Frames[id]
        end
    end

    if topFrame then
        for _,textentry in pairs(topFrame.children.textentries) do
            if goo.getIntersect(x, y, textentry.x, textentry.y,
                textentry.w, textentry.l) == true and textentry.editable == true then
                textentry.editing = true
                textentry.onSelect()
                found = true
            else
                textentry.editing = false
            end
        end
    end

    love.keyboard.setTextInput(found)
end

function goo.textentryTextInput(text)
    if text ~= "`" then
        for _,textentry in pairs(goo.TextEntries) do
            if textentry.editing == true then
                textentry.value = (textentry.value .. text)

                if (goo.getTextWidth(string.sub(textentry.value, (textentry.dist + 1),
                    string.len(textentry.value))) + goo.getTextWidth(text)) > textentry.w then
                    textentry.dist = (textentry.dist + 1)
                end

                textentry.cx = (textentry.x + goo.getTextWidth(string.sub(textentry.value,
                    (textentry.dist + 1), string.len(textentry.value))))
                textentry.cx = (textentry.cx + 3)
                break
            end
        end

        local topFrame = nil

        for _,id in pairs(goo.frameDrawOrder) do
            if goo.Frames[id] then
                topFrame = goo.Frames[id]
            end
        end

        if topFrame then
            for _,textentry in pairs(topFrame.children.textentries) do
                if textentry.editing == true then
                    textentry.value = (textentry.value .. text)

                    if (goo.getTextWidth(string.sub(textentry.value, (textentry.dist + 1),
                        string.len(textentry.value))) + goo.getTextWidth(text)) > textentry.w then
                        textentry.dist = (textentry.dist + 1)
                        if (goo.getTextWidth(string.sub(textentry.value, (textentry.dist + 1),
                            string.len(textentry.value))) + goo.getTextWidth(text)) > textentry.w then
                            textentry.dist = (textentry.dist + 1)
                        end
                    end

                    textentry.cx = (textentry.x + goo.getTextWidth(string.sub(textentry.value, (textentry.dist + 1),
                        string.len(textentry.value))))
                    textentry.cx = (textentry.cx + 3)
                    break
                end
            end
        end
    end
end

function goo.textentryKeyPressed(key)
    for _,textentry in pairs(goo.TextEntries) do
        if textentry.editing == true then
            if key == "backspace" then
                if string.len(textentry.value) >= 1 then
                    textentry.cx = (textentry.cx - goo.getTextWidth(string.sub(textentry.value, string.len(textentry.value),
                        string.len(textentry.value))))
                    if string.len(textentry.value) == 1 then
                        textentry.value = ""
                    else
                        textentry.value = string.sub(textentry.value, 0, string.len(textentry.value) - 1)
                    end

                    if textentry.dist > 0 then
                        textentry.dist = (textentry.dist - 1)
                        textentry.cx = (textentry.cx + goo.getTextWidth(string.sub(textentry.value, textentry.dist + 1,
                            textentry.dist + 1)))
                    end
                end
            elseif key == "return" or key == "kpenter" then
                textentry.onEnter()
            elseif key == "tab" then
                textentry.onTab()
            elseif key == "v" and love.keyboard.isDown("lctrl") then
                textentry:SetValue(textentry:GetValue() .. love.system.getClipboardText())
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
        for _,textentry in pairs(topFrame.children.textentries) do
            if textentry.editing == true then
                if key == "backspace" then
                    if string.len(textentry.value) >= 1 then
                        textentry.cx = (textentry.cx - goo.getTextWidth(string.sub(textentry.value,
                            string.len(textentry.value), string.len(textentry.value))))
                        if string.len(textentry.value) == 1 then
                            textentry.value = ""
                        else
                            textentry.value = string.sub(textentry.value, 0, string.len(textentry.value) - 1)
                        end

                        if textentry.dist > 0 then
                            textentry.dist = (textentry.dist - 1)
                            textentry.cx = (textentry.cx+goo.getTextWidth(string.sub(textentry.value,textentry.dist + 1,
                                textentry.dist + 1)))
                        end
                    end
                elseif key == "return" or key == "kpenter" then
                    textentry.onEnter()
                elseif key == "tab" then
                    textentry.onTab()
                elseif key == "v" and love.keyboard.isDown("lctrl") then
                    textentry:SetValue(textentry:GetValue() .. love.system.getClipboardText())
                end
            end
        end
    end
end

goo.addElement("GTextEntry",
    goo.TextEntryMeta,
    goo.TextEntries,
    goo.textentryDraw,
    goo.textentryDrawIndividual,
    goo.textentryMousePressed,
    goo.textentryMouseReleased,
    nil)
