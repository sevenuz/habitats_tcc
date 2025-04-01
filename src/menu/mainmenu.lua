suit = require 'lib/suit'
Lighter = require("lib/lighter")

local lighter = Lighter()

return {
	load = function()
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

		res.frame = love.graphics.newImage('sprites/frame.png')
		sphere2Image = love.graphics.newImage('sprites/sphere.png')
		-- particle system
		pSystem = love.graphics.newParticleSystem(sphere2Image, 32)
		pSystem:setParticleLifetime(1, 5)
		pSystem:setLinearAcceleration(-20, -20, 20, 20)
		pSystem:setSpeed(20)
		pSystem:setRotation(10, 20)
		pSystem:setSpin(20, 50)
	end,

	update = function(dt)
		lightX, lightY = love.mouse.getPosition()
		lighter:updateLight(light, lightX, lightY)

		pSystem:update(dt)
	end,

	draw = function()
		love.graphics.draw(res.frame)

		love.graphics.draw(pSystem, love.mouse.getX(), love.mouse.getY())

		love.graphics.polygon('fill', wall)
		lighter:drawLights()

		love.graphics.setFont(love.graphics.newFont(60))
		love.graphics.setColor(255, 255, 255)
		love.graphics.printf(string.format('%q', TITLE),
			windowWidth / 5.5, windowHeight / 3.5, 500, 'center')
	end,

	keypressed = function(key, scancode, isrepeat)
		if key == "return" then
			stack:push(GAME)
		end
		if key == "c" then
			stack:push(CREDITS)
		end
		suit.keypressed(key)
	end,

	mousepressed = function(x, y, button, istouch, presses)
		if love.mouse.isDown(1) then
			pSystem:emit(32)
		end
	end,

	textinput = function(text)
		suit.textinput(text)
	end,

	wheelmoved = function(x, y)
		suit.wheelmoved(x, y)
	end,

	quit = function()
		lighter:removeLight(light)
		lighter:removePolygon(wall)
	end
}
