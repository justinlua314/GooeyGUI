# GooeyGUI
GUI Library for Love 2d inspired by the Derma Library from Gmod

![image](https://user-images.githubusercontent.com/75858424/125485915-d5ee67b7-fe1c-4ca8-a51a-3732177d8a85.png)

To use...

Simply require the goo_core.lua file anywhere
On line 2 of goo_core.lua make sure goo.dir is set to where your gooey folder is.

When you want to use the lib

Call goo.draw() in love.draw()

Call goo.keypressed(key) in love.keypressed(key, unicode)

Call goo.textInput(text) in love.textInput(text)

Call goo.mousePressed(x, y, button) in love.mousepressed(x, y, button)

Call goo.mouseReleased(x, y, button) in love.mousereleased(x, y, button)

Call goo.mouseMoved(x, y, dx, dy) in love.mousemoved(x, y, dx, dy)


And it should just work.
I don't have any good doccumentation yet, but just check the element files to see the gets and sets hooks.
I think everything in there is pretty self explanitory



USAGE
You are free to use, publish, modify, and reupload this all you want.
