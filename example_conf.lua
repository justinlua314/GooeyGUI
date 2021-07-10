function love.conf(t)
	t.window.title = "game"
	t.console = true

	t.window.width = 1024
	t.window.height = 576

	t.modules.joystick = false
	t.modules.physics = false
	t.modules.timer = true
end
