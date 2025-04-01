suit = require 'lib/suit'

local buffer = {}
local offset = 0
local input = { text = "" }
local eval_mode = false

local function _push(text, color)
	table.insert(buffer, { text = text, color = color })
	offset = #buffer - 9
end

return {
	push = function(text, color)
		if not text then
			return
		end
		color = color or { 1, 1, 1 }
		_push(tostring(text), color)
	end,

	load = function() end,

	update = function(dt)
		love.graphics.setFont(love.graphics.newFont(14))
		love.graphics.setColor(0, 0, 0)
		if suit.Input(input, 0, 300, windowWidth, 20).submitted then
			if input.text == "exit" then
				if eval_mode then
					eval_mode = false
				else
					show_debug = false
				end
			end
			if eval_mode then
				_push(">> " .. input.text, { 0, 1, 0 })
				local res, msg = loadstring(input.text)
				if res then
					local resres = res()
					if resres then
						_push(tostring(resres), { 0, 1, 0 })
					end
				else
					_push(tostring(msg), { 1, 0, 0 })
				end
			else
				_push(input.text, { 1, 1, 1 })
			end
			if input.text == "eval" then
				eval_mode = true
					_push("!!! WARNING, eval is evil !!!", { 1, 1, 0.5 })
			end
			input.text = ""
		end
	end,

	draw = function()
		love.graphics.setColor(.08, .58, .81, 0.9)
		-- bg
		love.graphics.rectangle("fill", 0, 0, windowWidth, 300)

		love.graphics.setFont(love.graphics.newFont(14))

		for i, value in ipairs(buffer) do
			if i < offset then
				goto continue
			end
			if i > 9 + offset then
				break
			end
			love.graphics.setColor(value.color[1], value.color[2], value.color[3])
			love.graphics.printf(tostring(value.text), 20, (i - offset) * 30, 500, 'left')
			-- delimiter
			if i > 1 then
				love.graphics.setColor(.48, .58, .81, 1)
				love.graphics.rectangle("fill", 0, (i - offset) * 30 - 10, windowWidth, 1)
			end
			::continue::
		end
		if #buffer > 9 then
			-- scrollbar
			love.graphics.setColor(.48, .58, .81, 1)
			love.graphics.rectangle("fill", windowWidth - 5, 0, 5, 300)
			love.graphics.setColor(255, 255, 255)
			love.graphics.rectangle("fill", windowWidth - 5, 0, 5, offset / (#buffer - 9) * 300)
		end
	end,

	keypressed = function(key, scancode, isrepeat)
		suit.keypressed(key)
	end,

	textinput = function(text)
		suit.textinput(text)
	end,

	wheelmoved = function(x, y)
		if y < 0 and offset < #buffer - 9 then
			offset = offset + 1
		end
		if y > 0 and offset > 0 then
			offset = offset - 1
		end
		suit.wheelmoved(x, y)
	end
}
