require("libraries/gooey/goo_core")

function love.load()
    goo.spawn("test")
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
