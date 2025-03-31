suit = require 'lib/suit'

local buffer = {}
local input = { text = "" }

return {
	load = function()
		table.insert(buffer, "test")
	end,

	update = function(dt)
		-- put 10 extra pixels between cells in each direction
		love.graphics.setFont(love.graphics.newFont(14))
		love.graphics.setColor(0, 0, 0)
		if suit.Input(input, 0, 300, windowWidth, 20).submitted then
			table.insert(buffer, input.text)
			if input.text == "exit" then
				show_debug = false
			end
			input.text = ""
		end
	end,

	draw = function()
		love.graphics.setColor(.08, .58, .81, 0.7)
		-- create a "filled" rectangle in position 30x30 with size 60x60
		love.graphics.rectangle("fill", 0, 0, windowWidth, 300)

		love.graphics.setFont(love.graphics.newFont(14))

		for i, value in ipairs(buffer) do
			if i > 9 then
				break
			end
			love.graphics.setColor(255, 255, 255)
			love.graphics.printf(tostring(value), 20, i * 30, 500, 'left')
			if i > 1 then
				love.graphics.setColor(.48, .58, .81, 0.8)
				love.graphics.rectangle("fill", 0, i * 30 - 10, windowWidth, 1)
			end
		end
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
