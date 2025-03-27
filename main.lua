Card = require("src/card")
Deck = require("src/deck")
Stack = require("src/util/stack")

-- https://github.com/speakk/lighter
Lighter = require("lib/lighter")
credits_menu = require("src/menu/credits")

local VERSION = '0.0.1'

local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()

local lighter = Lighter()

TITLE = 'Habitats TTC'
MAIN_MENU = 0
GAME = 1
SETTINGS = 2
CREDITS = 3

function love.load()
	stack = Stack:new()
	stack:push(MAIN_MENU)
	credits_menu.load()

	wall = {
		100, 100,
		300, 100,
		300, 300,
		100, 300
	}

	lighter:addPolygon(wall)

	local lightX, lightY = 500, 500

	-- addLight signature: (x,y,radius,r,g,b,a)
	light = lighter:addLight(lightX, lightY, 500, 1, 0.5, 0.5)


	winned = false

	-- Game timer
	startTime = 0
	gameTimer = 0

	-- Set title
	love.window.setTitle(TITLE)

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

	-- load sphere
	sphereImage = love.graphics.newImage('sprites/sphere.png')
	sphere2Image = love.graphics.newImage('sprites/sphere2.png')
	-- particle system
	pSystem = love.graphics.newParticleSystem(sphere2Image, 32)
	pSystem:setParticleLifetime(1, 5)
	pSystem:setLinearAcceleration(-20, -20, 20, 20)
	pSystem:setSpeed(20)
	pSystem:setRotation(10, 20)
	pSystem:setSpin(20, 50)

	-- Load cards sprites
	cardBackImage = love.graphics.newImage('sprites/cardback.png')
	cardBackQuad = love.graphics.newQuad(0, 0, adjustedCardWidth,
		adjustedCardHeight, adjustedCardWidth,
		adjustedCardHeight)
	cardFrontImage = love.graphics.newImage('sprites/cardfront.png')
	cardFrontQuad = love.graphics.newQuad(0, 0, adjustedCardWidth,
		adjustedCardHeight, adjustedCardWidth, adjustedCardHeight)
end

function love.draw()
	-- Draw background
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(backgroundImage, backgroundQuad, 0, 0)

	if stack:peek() == MAIN_MENU then
		show_mainmenu()
		return
	end

	if stack:peek() == CREDITS then
		credits_menu.draw()
		return
	end

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
end

function love.update(dt)
	lightX, lightY = love.mouse.getPosition()
	lighter:updateLight(light, lightX, lightY)

	pSystem:update(dt)

	if stack:peek() == CREDITS then
		credits_menu.update(dt)
	end

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
end

function love.mousepressed(x, y, button, istouch, presses)
	if stack:peek() == CREDITS then
		credits_menu.mousepressed(x, y, button, istouch, presses)
	end
	if stack:peek() == MAIN_MENU then
		if love.mouse.isDown(1) then
			pSystem:emit(32)
		end
		return
	end
	if stack:peek() == GAME then
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
end

function love.mousereleased(x, y, button, istouch, presses)
	if stack:peek() == CREDITS then
		credits_menu.mousereleased(x, y, button, istouch, presses)
	end
end

function love.mousemoved(x, y, dx, dy, istouch)
	if stack:peek() == CREDITS then
		credits_menu.mousemoved(x, y, dx, dy, istouch)
	end
end

function love.textinput(text)
	if stack:peek() == CREDITS then
		credits_menu.textinput(text)
	end
end

function love.wheelmoved(x, y)
	if stack:peek() == CREDITS then
		credits_menu.wheelmoved(x, y)
	end
end

function love.keypressed(key, scancode, isrepeat)
	-- print(key)
	if key == "escape" then
		if stack:peek() == GAME then
			-- Restart
			love.load()
		end
		if stack:size() > 1 then
			stack:pop()
		end
	end
	if key == "return" then
		if stack:peek() == MAIN_MENU then
			stack:push(GAME)
		end
	end
	if key == "c" then
		stack:push(CREDITS)
	end

	if stack:peek() == CREDITS then
		credits_menu.keypressed(key, scancode)
	end
end

function love.keyreleased(key, scancode)
	if stack:peek() == CREDITS then
		credits_menu.keyreleased(key, scancode)
	end
end

function love.focus(f)
	if not f then
		print("LOST FOCUS")
	else
		print("GAINED FOCUS")
	end
end

function love.quit()
	print("Thanks for playing! Come back soon!")
	-- Clean up
	lighter:removeLight(light)
	lighter:removePolygon(wall)
end

-- Show winned screen
function show_mainmenu()
	love.graphics.draw(sphereImage)

	love.graphics.draw(pSystem, love.mouse.getX(), love.mouse.getY())

	love.graphics.polygon('fill', wall)
	lighter:drawLights()

	love.graphics.setFont(love.graphics.newFont(60))
	love.graphics.setColor(255, 255, 255)
	love.graphics.printf(string.format('Welcome to \n%q', TITLE),
		windowWidth / 5.5, windowHeight / 3.5, 500, 'center')
end

-- Show winned screen
function show_winned()
	love.graphics.setFont(love.graphics.newFont(60))
	love.graphics.setColor(255, 255, 255)
	love.graphics.printf(string.format('You Win \nin\n%.2f sec!', gameTimer),
		windowWidth / 5.5, windowHeight / 3.5, 500, 'center')
end
