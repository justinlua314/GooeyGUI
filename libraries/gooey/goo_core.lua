goo = {} -- This is the only global variable that is used by this library
goo.dir = "libraries/gooey"

goo.elements = {}
goo.drawtable = {}
goo.updatetable = {}
goo.mousepressedtable = {}
goo.mousereleasedtable = {}
goo.mousemovedtable = {}

-- Source: http://lua-users.org/wiki/CopyTable
local function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            copies[orig] = copy
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function goo.create(element)
	if goo.elements[element] then 				-- If the element exists...
		local t = setmetatable({}, { 			-- define t as the meta table of the element stated
			__index = goo.elements[element].metatable
		})
		t.type = element
		local r = deepcopy(t) 					-- Split the element from being a pointer
		return r 								-- return the element
	end
end

function goo.addElement(name, 	-- Use this as a template of creating gooey elements
	metatable,
	IDTable,
	drawfunction,
	drawindividualfunction,
	mousepressedfunction,
	mousereleasedfunction,
	mousemovedfunction)

	if not goo.elements[name] then 			-- If the element doesn't already exist...
		local t = {}
		t.metatable = metatable
		t.IDTable = IDTable
		goo.elements[name] = t		-- Add the element

		if drawfunction then
			goo.drawtable[name] = drawfunction
		end

		if drawindividualfunction then
			goo.elements[name].drawFunc = drawindividualfunction -- Allows frames to draw children above other elements
		end

		if mousepressedfunction then
			goo.mousepressedtable[name] = mousepressedfunction
		end

		if mousereleasedfunction then
			goo.mousereleasedtable[name] = mousereleasedfunction
		end

		if mousemovedfunction then
			goo.mousemovedtable[name] = mousemovedfunction
		end
	end
end

function goo.getIntersect(x, y, targetX, targetY, targetWidth, targetLength)
	return (x >= targetX and x <= (targetX + targetWidth) and y >= targetY and y <= (targetY + targetLength))
end

function goo.getTextWidth(text, font)
	if type(text) == "string" then
		font = font or love.graphics.getFont()
		return font:getWidth(text)
	end
end

function goo.getTextHeight(text, font)
	if type(text) == "string" then
		font = font or love.graphics.getFont()
		return font:getHeight(text)
	end
end





function goo.draw()
	for _,v in pairs(goo.drawtable) do
		v()
	end
end

function goo.mousePressed(x, y, button)
	for _,v in pairs(goo.mousepressedtable) do
		v(x, y, button)
	end
end

function goo.mouseReleased(x, y, button)
	for _,v in pairs(goo.mousereleasedtable) do
		v(x, y, button)
	end
end

function goo.mouseMoved(x, y, dx, dy)
	for _,v in pairs(goo.mousemovedtable) do
		v(x, y, dx, dy)
	end
end

function goo.keypressed(key)
	goo.textentryKeyPressed(key)
end

function goo.textInput(text)
	goo.textentryTextInput(text)
end





local elements = love.filesystem.getDirectoryItems(goo.dir) 		-- Returns all the files the goo.dir directory
local requireList = {}

for _, file in ipairs(elements) do 									-- Require all files in the goo.dir directory that begin with goo_
	if string.sub(file, 1, 4) == "goo_" and file ~= "goo_core.lua" then
		if file == "goo_frame.lua" then
			require(goo.dir .. "/goo_frame")
		else
			file = string.sub(file, 1, (string.len(file) - 4))
			table.insert(requireList, file)
		end
	end
end

for _,file in pairs(requireList) do
	require(goo.dir .. "/" .. file)
end
