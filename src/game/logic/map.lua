return {
	---set in init
	dimension = nil,
	---map is 2d array, indexed first with heigth
	map = {},
	---init map with default values, map is 2d array, indexed first with heigth
	---if no default values are passed, it is randomly initilized
	---@param self table
	---@param width number between 0 and 100
	---@param heigth number
	---@param water? number
	---@param nutrians? number
	---@param sun? number
	init = function(self, width, heigth, water, nutrians, sun)
		assert(width > 0, "map width has to be greater 0")
		assert(heigth > 0, "map heigth has to be greater 0")
		self.dimension = { width = width, height = heigth }
		for i = 1, heigth, 1 do
			self.map[i] = {}
			for j = 1, width, 1 do
				self.map[i][j] = self.get_default_value(water, nutrians, sun)
			end
		end
	end,

	---Returns a named tuple with 3 entries
	---@param water? number
	---@param nutrians? number
	---@param sun? number
	get_default_value = function(water, nutrians, sun)
		water = water or math.random(100)
		nutrians = nutrians or math.random(100)
		sun = sun or math.random(100)
		assert(water >= 0 and water <= 100, "water not in percent")
		assert(nutrians >= 0 and nutrians <= 100, "nutrians not in percent")
		assert(sun >= 0 and sun <= 100, "sun not in percent")
		return { water = water, nutrians = nutrians, sun = sun }
	end,

	---execute given fn for all tiles
	---@param self table
	---@param f function
	for_each = function (self, f)
		for i = 1, self.dimension.height, 1 do
			for j = 1, self.dimension.width, 1 do
				f(i, j, self.map[i][j].water, self.map[i][j].nutrians, self.map[i][j].sun)
			end
		end
	end
}
