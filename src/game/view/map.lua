suit = require 'lib/suit'

local slider_water = { value = 1, min = 0, max = 100, step = 1 }
local slider_nutrians = { value = 1, min = 0, max = 100, step = 1 }
local slider_sun = { value = 1, min = 0, max = 100, step = 1 }

TILE_WATER = 1
TILE_GREEN = 2
TILE_SAND = 3

function choose_tile(water, nutrians, sun)
	if water > 33 and water > nutrians and water > sun then
		return TILE_WATER
	elseif nutrians > 33 and water > 19 and nutrians >= water then
		return TILE_GREEN
	else
		return TILE_SAND
	end
end

function blub(water, nutrians, sun)
	local sand1 = false
	local sand2 = false
	local green1 = false
	local green2 = false
	local water1 = false
	local water2 = false
	if sun > 66 and sun > water then
		sand1 = true
	end
	if water > 66 and water > sun then
		water1 = true
	end
	if sun > 66 and sun > nutrians then
		sand2 = true
	end
	if nutrians > 66 and nutrians > sun then
		green1 = true
	end
	if water > 33 then
		water2 = true
	end
	if nutrians > 33 then
		green2 = true
	end
	return water1, water2, green1, green2, sand1, sand2
end

return {
	load = function()
		img_bg = love.graphics.newImage('sprites/bg.png')
		img_card_back = love.graphics.newImage('sprites/card_back.png')
		img_card_front = love.graphics.newImage('sprites/card_front.png')
		img_tile_green = love.graphics.newImage('sprites/tile_green.png')
		img_tile_water = love.graphics.newImage('sprites/tile_water.png')
		img_tile_sand = love.graphics.newImage('sprites/tile_sand.png')

		img_blub_water1 = love.graphics.newImage('sprites/water_blub1.png')
		img_blub_water2 = love.graphics.newImage('sprites/water_blub2.png')
		img_blub_green1 = love.graphics.newImage('sprites/green_blub1.png')
		img_blub_green2 = love.graphics.newImage('sprites/green_blub2.png')
		img_blub_sand1 = love.graphics.newImage('sprites/sand_blub1.png')
		img_blub_sand2 = love.graphics.newImage('sprites/sand_blub2.png')
	end,

	update = function(dt)
		suit.layout:reset(0, 0)

		-- put 10 extra pixels between cells in each direction
		suit.layout:padding(10, 10)
		love.graphics.setFont(love.graphics.newFont(14))
		suit.Label("Water: " .. tostring(slider_water.value), suit.layout:row(100,30))
		suit.Slider(slider_water, suit.layout:row())

		suit.Label("Nutrians: " .. tostring(slider_nutrians.value), suit.layout:row())
		suit.Slider(slider_nutrians, suit.layout:row())

		suit.Label("Sun: " .. tostring(slider_sun.value), suit.layout:row())
		suit.Slider(slider_sun, suit.layout:row())
	end,

	draw = function()
		love.graphics.draw(img_bg, 0, 0)
		local tile = choose_tile(slider_water.value, slider_nutrians.value, slider_sun.value)
		local bw1, bw2, bg1, bg2, bs1, bs2 = blub(slider_water.value, slider_nutrians.value, slider_sun.value)
		if tile == TILE_SAND then
			love.graphics.draw(img_tile_sand, windowWidth / 4, 10)
		elseif tile == TILE_GREEN then
			love.graphics.draw(img_tile_green, windowWidth / 4, 10)
		elseif tile == TILE_WATER then
			love.graphics.draw(img_tile_water, windowWidth / 4, 10)
		end

		if bw1 and tile ~= TILE_WATER then
			love.graphics.draw(img_blub_water1, windowWidth / 4, 10)
		end
		if bw2 and tile ~= TILE_WATER then
			love.graphics.draw(img_blub_water2, windowWidth / 4, 10)
		end
		if bg1 then
			love.graphics.draw(img_blub_green1, windowWidth / 4, 10)
		end
		if bg2 then
			love.graphics.draw(img_blub_green2, windowWidth / 4, 10)
		end
		if bs1 then
			love.graphics.draw(img_blub_sand1, windowWidth / 4, 10)
		end
		if bs2 then
			love.graphics.draw(img_blub_sand2, windowWidth / 4, 10)
		end

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
