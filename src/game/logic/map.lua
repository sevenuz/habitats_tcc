---@alias element { water: number, nutrians: number, sun: number }

---@param water? number
---@param nutrians? number
---@param sun? number
---@return element
local function get_default_value(water, nutrians, sun)
	water = water or math.random(100)
	nutrians = nutrians or math.random(100)
	sun = sun or math.random(100)
	assert(water >= 0 and water <= 100, "water not in percent")
	assert(nutrians >= 0 and nutrians <= 100, "nutrians not in percent")
	assert(sun >= 0 and sun <= 100, "sun not in percent")
	return { water = water, nutrians = nutrians, sun = sun }
end

---@class map
local map = {}

---is only for the view and is reset after calling needs_redraw()
---@type boolean
map.redraw = true

---check if it needs a redraw, resets draw state
---@return boolean
function map.needs_redraw()
	local r = map.redraw
	map.redraw = false
	return r
end

---set in init
---width = columns, height = lines
---@type { width: number, height: number }
map.dimension = {}

---map is 2d array, indexed first with heigth
---@type element[][]
map.map = {}

---init map with default values, map is 2d array, indexed first with heigth
---if no default values are passed, it is randomly initilized
---@param width number between 0 and 100
---@param heigth number
---@param water? number
---@param nutrians? number
---@param sun? number
function map.init(width, heigth, water, nutrians, sun)
	assert(width > 0, "map width has to be greater 0")
	assert(heigth > 0, "map heigth has to be greater 0")
	map.dimension = { width = width, height = heigth }
	for i = 1, heigth, 1 do
		map.map[i] = {}
		for j = 1, width, 1 do
			map.map[i][j] = get_default_value(water, nutrians, sun)
		end
	end
end

---execute given fn for all tiles
---@param f function(line: number, column: number, element: element)
function map.for_each(f)
	for i = 1, map.dimension.height, 1 do
		for j = 1, map.dimension.width, 1 do
			f(i, j, get_default_value(map.map[i][j].water, map.map[i][j].nutrians, map.map[i][j].sun))
		end
	end
end

---average of elements over all tiles
---@return element
function map.get_element_average()
	local n = map.dimension.width * map.dimension.height
	local aw = 0
	local an = 0
	local as = 0
	map.for_each(function(_, _, element)
		aw = aw + element.water
		an = an + element.nutrians
		as = as + element.sun
	end)
	return { water = aw / n, nutrians = an / n, sun = as / n }
end

---sets the tile at the given index to the given element
---@param line number
---@param column number
---@param element element
function map.set_tile_to(line, column, element)
	map.map[line][column] = element
	map.redraw = true
end

---changes the tile at the given index by the given element relativly
---@param line number
---@param column number
---@param element element
function map.change_tile_by(line, column, element)
	map.map[line][column].water = map.map[line][column].water + element.water
	map.map[line][column].nutrians = map.map[line][column].nutrians + element.nutrians
	map.map[line][column].sun = map.map[line][column].sun + element.sun
	map.redraw = true
end

return map
