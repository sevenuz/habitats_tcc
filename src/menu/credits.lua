suit = require 'lib/suit'

local show_message = false
local slider = { value = 1, min = 0, max = 2 }
local input = { text = "" }

return {
	load = function() end,

	update = function(dt)
		suit.layout:reset(100, 100)

		-- put 10 extra pixels between cells in each direction
		suit.layout:padding(10, 10)
		love.graphics.setFont(love.graphics.newFont(14))
		if suit.Button("Hello, World!", suit.layout:row(300, 30)).hit then
			show_message = true
		end

		-- if the button was pressed at least one time, but a label below
		if show_message then
			suit.Label("How are you today?", suit.layout:row())
		end
		suit.Slider(slider, suit.layout:row())
		suit.Label(tostring(slider.value), suit.layout:row())
		suit.Input(input, suit.layout:row())
		suit.Label("Hello, " .. input.text, { align = "left" }, suit.layout:row())
	end,

	draw = function()
		suit.draw()
	end,

	keypressed = function(key, scancode, isrepeat)
		suit.keypressed(key)
	end,

	keyreleased = function(key, scancode)
	end,

	mousepressed = function(x, y, button, istouch, presses)
	end,

	mousereleased = function(x, y, button, istouch, presses)
	end,

	mousemoved = function(x, y, dx, dy, istouch)
	end,

	textinput = function(text)
		suit.textinput(text)
	end,

	wheelmoved = function(x, y)
		suit.wheelmoved(x, y)
	end
}
