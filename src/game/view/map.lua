local canvas_map_width, canvas_map_height
local canvas_map
local map_modifier = { dx = 0, dy = 0, scale = 1 }

local TILE_WATER = 1
local TILE_GREEN = 2
local TILE_SAND = 3

-- text width for font size 10 for text "100%"
local text_width_10

local function choose_tile(water, nutrians, sun)
	if water > 33 and water > nutrians and water > sun then
		return TILE_WATER
	elseif nutrians > 33 and water > 19 and nutrians >= water then
		return TILE_GREEN
	else
		return TILE_SAND
	end
end

local function blub(water, nutrians, sun)
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

local function draw_tile(x, y, element)
	local tile = choose_tile(element.water, element.nutrians, element.sun)
	local bw1, bw2, bg1, bg2, bs1, bs2 = blub(element.water, element.nutrians, element.sun)
	if tile == TILE_SAND then
		love.graphics.draw(res.tile.base.sand, x, y)
	elseif tile == TILE_GREEN then
		love.graphics.draw(res.tile.base.green, x, y)
	elseif tile == TILE_WATER then
		love.graphics.draw(res.tile.base.water, x, y)
	end

	if bw1 and tile ~= TILE_WATER then
		love.graphics.draw(res.tile.blub.water1, x, y)
	end
	if bw2 and tile ~= TILE_WATER then
		love.graphics.draw(res.tile.blub.water2, x, y)
	end
	if bg1 then
		love.graphics.draw(res.tile.blub.green1, x, y)
	end
	if bg2 then
		love.graphics.draw(res.tile.blub.green2, x, y)
	end
	if bs1 then
		love.graphics.draw(res.tile.blub.sand1, x, y)
	end
	if bs2 then
		love.graphics.draw(res.tile.blub.sand2, x, y)
	end
	love.graphics.draw(res.tile.frame, x, y)
	-- draw elements per field
	tile_width_px, tile_height_px = res.tile.frame:getDimensions()
	love.graphics.setColor(1, 0, 0)
	love.graphics.printf(math.floor(element.sun + .5) .. "%", x, y, 500, 'left')
	love.graphics.setColor(0, 0, 1)
	love.graphics.printf(tostring(math.floor(element.water + .5)) .. "%", x + text_width_10, y, 500, 'left')
	love.graphics.setColor(0, 1, 0)
	love.graphics.printf(math.floor(element.nutrians + .5) .. "%", x + text_width_10 * 2, y, 500, 'left')
	love.graphics.setColor(1, 1, 1)
end

return {
	load = function()
		res.tile = {
			frame = love.graphics.newImage('sprites/tile_frame.png'),
			base = {
				green = love.graphics.newImage('sprites/tile_base_green.png'),
				water = love.graphics.newImage('sprites/tile_base_water.png'),
				sand = love.graphics.newImage('sprites/tile_base_sand.png'),
			},
			blub = {
				water1 = love.graphics.newImage('sprites/tile_blub_water1.png'),
				water2 = love.graphics.newImage('sprites/tile_blub_water2.png'),
				green1 = love.graphics.newImage('sprites/tile_blub_green1.png'),
				green2 = love.graphics.newImage('sprites/tile_blub_green2.png'),
				sand1 = love.graphics.newImage('sprites/tile_blub_sand1.png'),
				sand2 = love.graphics.newImage('sprites/tile_blub_sand2.png'),
			}
		}
		res.elements = {
			water = love.graphics.newImage('sprites/water.png'),
			nutrians = love.graphics.newImage('sprites/nutrians.png'),
			sun = love.graphics.newImage('sprites/sun.png'),
			sphere = love.graphics.newImage('sprites/sphere.png'),
		}

		love.graphics.setFont(love.graphics.newFont(10))
		text_width_10 = love.graphics.getFont():getWidth("100%")

		tile_width_px, tile_height_px = res.tile.frame:getDimensions()
		canvas_map_width = gamecontroller.get_map().dimension.width * tile_width_px
		canvas_map_height = gamecontroller.get_map().dimension.height * tile_height_px
		canvas_map = love.graphics.newCanvas(canvas_map_width, canvas_map_height)
	end,

	update = function(dt) end,

	draw = function()
		if gamecontroller.get_map().needs_redraw() then
			debug.push("redraw map")
			love.graphics.setCanvas(canvas_map)
			love.graphics.clear()
			love.graphics.setFont(love.graphics.newFont(10))
			gamecontroller.get_map().for_each(
				function(line, column, element)
					draw_tile((column - 1) * tile_width_px, (line - 1) * tile_height_px, element)
				end
			)
			love.graphics.setCanvas()
		end

		love.graphics.push()
		-- does not work with move, aahahhahahhahahha
		--love.graphics.scale(map_modifier.scale)
		love.graphics.translate(map_modifier.dx, map_modifier.dy)

		-- center map
		love.graphics.draw(canvas_map, (windowWidth - canvas_map_width) / 2, (windowHeight - canvas_map_height) / 2)

		love.graphics.pop()

		love.graphics.draw(res.elements.nutrians)
		love.graphics.draw(res.elements.sphere)
		love.graphics.draw(res.elements.sun)
		love.graphics.draw(res.elements.water)

		local e = gamecontroller.get_map().get_element_average()
		love.graphics.setFont(love.graphics.newFont(28))
		love.graphics.setColor(1, 0, 0)
		love.graphics.printf(math.floor(e.sun + .5) .. "%", 1688, 350, 500, 'left')
		love.graphics.setColor(0, 0, 1)
		love.graphics.printf(tostring(math.floor(e.water + .5)) .. "%", 1679, 493, 500, 'left')
		love.graphics.setColor(0, 1, 0)
		love.graphics.printf(math.floor(e.nutrians + .5) .. "%", 1682, 626, 500, 'left')
		love.graphics.setColor(1, 1, 1)
	end,

	keypressed = function(key, scancode, isrepeat) end,

	textinput = function(text) end,

	wheelmoved = function(x, y)
		-- TODO magic numbers into settings
		if y < 0 and map_modifier.scale > 0.5 then
			map_modifier.scale = map_modifier.scale - 0.2
		end
		if y > 0 and map_modifier.scale < 2.0 then
			map_modifier.scale = map_modifier.scale + 0.2
		end
	end,

	mousemoved = function(x, y, dx, dy, istouch)
		-- TODO shift viewport of map
		-- TODO magic numbers into settings
		local cw, ch = canvas_map:getDimensions()
		local ppx = (x / windowWidth) - 0.5
		local ppy = (y / windowHeight) - 0.5
		map_modifier.dx = cw * -ppx
		map_modifier.dy = ch * -ppy
	end
}
