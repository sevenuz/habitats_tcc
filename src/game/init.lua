Card = require("src/game/card")
Deck = require("src/game/deck")

-- Show winned screen
function show_winned()
	love.graphics.setFont(love.graphics.newFont(60))
	love.graphics.setColor(255, 255, 255)
	love.graphics.printf(string.format('You Win \nin\n%.2f sec!', gameTimer),
		windowWidth / 5.5, windowHeight / 3.5, 500, 'center')
end

return {
	load = function()
		winned = false

		-- Game timer
		startTime = 0
		gameTimer = 0

		-- Create new deck
		deck = Deck:new()

		-- Deck params
		local cardWidth = 90
		local cardHeight = 120
		local gridSize = 28
		local spacing = 15

		-- Fill deck
		deck:fill(windowWidth, windowHeight, cardWidth, cardHeight, gridSize,
			spacing)

		-- Suffle added cards
		deck:shuffle()

		-- Get cards size for own sprites
		adjustedCardWidth = deck:get(1).width
		adjustedCardHeight = deck:get(1).height

		-- Load background sprite
		backgroundQuad = love.graphics.newQuad(0, 0, windowWidth, windowHeight, 400, 400)
		backgroundImage = love.graphics.newImage('sprites/back.png')
		backgroundImage:setWrap('repeat', 'repeat')

		-- Load cards sprites
		cardBackImage = love.graphics.newImage('sprites/cardback.png')
		cardBackQuad = love.graphics.newQuad(0, 0, adjustedCardWidth,
			adjustedCardHeight, adjustedCardWidth,
			adjustedCardHeight)
		cardFrontImage = love.graphics.newImage('sprites/cardfront.png')
		cardFrontQuad = love.graphics.newQuad(0, 0, adjustedCardWidth,
			adjustedCardHeight, adjustedCardWidth, adjustedCardHeight)
	end,

	draw = function()
		-- Check winned
		if winned then
			show_winned()
			return
		end

		-- Iterate over cards
		for i = 1, deck:count() do
			local d = deck:get(i)

			love.graphics.setColor(255, 255, 255, 255)

			if not d.isSolved then
				-- Draw card
				if d.isOpened then
					love.graphics.draw(cardFrontImage, cardFrontQuad, d.x, d.y)

					-- Params for card text
					local limit = 60
					local x = (d.x + d.width / 2) - limit / 2
					local y = (d.y + d.height / 2) - limit / 4
					local cardText = (d.isOpened and d.name or "#")

					-- Draw card text
					love.graphics.setFont(love.graphics.newFont(limit / 2))
					love.graphics.setColor(255, 0, 0)
					love.graphics.printf(cardText, x, y, limit, 'center')
				else
					love.graphics.draw(cardBackImage, cardBackQuad, d.x, d.y)
				end
			end
		end

		-- Draw version
		love.graphics.setFont(love.graphics.newFont(11))
		love.graphics.setColor(255, 255, 255)
		love.graphics.print('v' .. VERSION, windowWidth - 40, windowHeight - 15)

		-- Draw game timer
		if startTime > 0 and not winned then
			gameTimer = love.timer.getTime() - startTime
		end
		love.graphics.print(string.format('%.2f', gameTimer), 0, 0)
	end,

	update = function(dt)
		-- Check count of openned cards
		if deck:solvedCount() == deck:count() then
			winned = true
			return
		end

		local firstCard = nil
		local secondCard = nil

		-- Search opened cards
		for i = 1, deck:count() do
			local c = deck:get(i)

			if c.isOpened and not c.isSolved and firstCard == nil then
				firstCard = c
				goto continue
			end

			if c.isOpened and not c.isSolved and secondCard == nil then
				secondCard = c
			end
			::continue::
		end

		-- Update card status
		if firstCard ~= nil and secondCard ~= nil then
			if (firstCard.name == secondCard.name) then
				firstCard.isSolved = true
				secondCard.isSolved = true
			else
				firstCard:autoclose(love.timer.getTime())
				secondCard:autoclose(love.timer.getTime())
			end

			return
		end

		-- Autoclose
		if firstCard ~= nil then firstCard:autoclose(love.timer.getTime()) end

		-- Autoclose
		if secondCard ~= nil then secondCard:autoclose(love.timer.getTime()) end
	end,

	mousepressed = function(x, y, button, istouch, presses)
		-- Left button pressed
		if button == 1 then
			if deck:openedCount() >= 2 then
				deck:closeAll()
			else
				-- Iterate over cards
				for i = 1, deck:count() do
					local c = deck:get(i)

					-- Search card by coords
					if not c.isSolved and c:inside(x, y) then
						c.isOpened = true
						c.openedTime = love.timer.getTime()

						-- First set game timer
						if startTime == 0 then
							startTime = love.timer.getTime()
						end
					end
				end
			end
		end
	end
}
