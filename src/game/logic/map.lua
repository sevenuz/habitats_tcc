---@alias element { water: number, nutrians: number, sun: number }

---@class map
local map = {}

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
			map.map[i][j] = map.get_default_value(water, nutrians, sun)
		end
	end
end

---Returns a named tuple with 3 entries
---@param water? number
---@param nutrians? number
---@param sun? number
---@return element
function map.get_default_value(water, nutrians, sun)
	water = water or math.random(100)
	nutrians = nutrians or math.random(100)
	sun = sun or math.random(100)
	assert(water >= 0 and water <= 100, "water not in percent")
	assert(nutrians >= 0 and nutrians <= 100, "nutrians not in percent")
	assert(sun >= 0 and sun <= 100, "sun not in percent")
	return { water = water, nutrians = nutrians, sun = sun }
end

---execute given fn for all tiles
---@param f function(line: number, column: number, water: number, nutrians: number, sun:number)
function map.for_each(f)
	for i = 1, map.dimension.height, 1 do
		for j = 1, map.dimension.width, 1 do
			f(i, j, map.map[i][j].water, map.map[i][j].nutrians, map.map[i][j].sun)
		end
	end
end

return map
