local map = require("src/game/view/map")

local card_width, card_height
local canvas_hand_width, canvas_hand_height
local canvas_shop_width, canvas_shop_height
local canvas_hand, canvas_shop

--TODO magic numbers and stuff...
---draws card with frame and everything
---@param card card
---@param x number
---@param y number
local function draw_card(card, x, y)
	love.graphics.draw(res.card.front, x, y)
	love.graphics.setFont(love.graphics.newFont(28))
	love.graphics.setColor(0, 0, 1)
	love.graphics.printf(tostring(card.energy), x + 37, y + 30, 500, 'left')
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(love.graphics.newFont(12))
	love.graphics.printf(card.text, x + 50, y + 370, 275, 'left')
	love.graphics.setColor(1, 1, 1)
end

---draws backside and a number with the amount of cards
---@param ncards number of cards in deck
---@param x number
---@param y number
local function draw_deck(ncards, x, y)
	love.graphics.draw(res.card.back, x, y)
	love.graphics.setFont(love.graphics.newFont(28))
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf(tostring(ncards), x + (card_width / 2) - 20, y + (card_height / 2), 500, 'left')
end

local function draw_hand()
	gamecontroller.get_hand().for_each(function(index, card)
		draw_card(card, (index - 1) * (card_width - 150), 0)
	end)
end

local function draw_shop()
	gamecontroller.get_shop().for_each(function(index, card)
		draw_card(card, (index - 1) * (card_width - 275), 0)
	end)
end

return {
	load = function()
		res.card = {
			front = love.graphics.newImage('sprites/card_front.png'),
			back = love.graphics.newImage('sprites/card_back.png'),
			bar = love.graphics.newImage('sprites/card_bar.png'),
		}
		card_width, card_height = res.card.back:getDimensions()
		map.load()
	end,

	update = function(dt)
		map.update(dt)
	end,

	draw = function()
		map.draw()

		--draw_card(gamecontroller.get_hand().cards[1], (windowWidth - card_width) / 2, (windowHeight - card_height) / 2)

		love.graphics.draw(res.frame)

		if gamecontroller.get_hand().needs_redraw() then
			debug.push("redraw hand")
			canvas_hand_width = #gamecontroller.get_hand().cards * (card_width - 150) + 150
			canvas_hand_height = card_height
			canvas_hand = love.graphics.newCanvas(canvas_hand_width, canvas_hand_height)
			love.graphics.setCanvas(canvas_hand)
			draw_hand()
			love.graphics.setCanvas()
		end
		if gamecontroller.get_shop().needs_redraw() then
			debug.push("redraw shop")
			canvas_shop_width = #gamecontroller.get_shop().cards * (card_width - 275) + 275
			canvas_shop_height = card_height
			canvas_shop = love.graphics.newCanvas(canvas_shop_width, canvas_shop_height)
			love.graphics.setCanvas(canvas_shop)
			draw_shop()
			love.graphics.setCanvas()
		end
		draw_deck(#gamecontroller.get_deck().cards, 20, 1080 - 400)
		love.graphics.draw(canvas_hand, (1920 - canvas_hand_width) / 2, 1080 - 300)
		love.graphics.draw(canvas_shop, 20, 20)
	end,

	keypressed = function(key, scancode, isrepeat)
		map.keypressed(key, scancode)
	end,

	textinput = function(text)
		map.textinput(text)
	end,

	wheelmoved = function(x, y)
		map.wheelmoved(x, y)
	end,

	mousemoved = function(x, y, dx, dy, istouch)
		map.mousemoved(x, y, dx, dy, istouch)
	end
}
