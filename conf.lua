__picolove_version = "0.1.0"

scale = 4
__pico_resolution = { 128, 128 }

function love.conf(t)
	t.console = true

	t.identity = "Celia"

	t.version = "11.3"

	t.window.title = "Celia"
	t.window.icon = "icon.png"
	t.window.width = 1344
	t.window.height = 768
	t.window.resizable = true
end

return {
	-- automatically enable pianoroll columns when reading a file
	auto_display_inputs = false,
}
