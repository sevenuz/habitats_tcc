suit = require 'lib/suit'

local buffer = {}
local input = { text = "" }

local bg = {
	0, 0,
	windowHeight, 0,
	windowHeight, 300,
	0, 300
}

return {
	load = function()
		table.insert(buffer, "test")
	end,

	update = function(dt)
		suit.layout:reset(100, 100)

		-- put 10 extra pixels between cells in each direction
		love.graphics.setFont(love.graphics.newFont(14))
		love.graphics.setColor(0, 0, 0)

		for i, value in ipairs(buffer) do
			if i > 14 then
				break
			end
			suit.Label(tostring(value), 0, i * 20, windowWidth, 20)
		end
		if suit.Input(input, 0, 300, windowWidth, 20).submitted then
			table.insert(buffer, input.text)
			if input.text == "exit" then
				show_debug = false
			end
			input.text = ""
		end
	end,

	draw = function()
		love.graphics.setColor(1, 0, 0)
		love.graphics.polygon('fill', bg)
		suit.draw()
	end,

	keypressed = function(key, scancode, isrepeat)
		suit.keypressed(key)
	end,

	textinput = function(text)
		suit.textinput(text)
	end,

	wheelmoved = function(x, y)
		suit.wheelmoved(x, y)
	end
}
