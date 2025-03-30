return {
	---map is 2d array, indexed first with heigth
	map = {},
	---init map with default values, map is 2d array, indexed first with heigth
	---@param self any
	---@param width number
	---@param heigth number
	---@param water number
	---@param nutrians number
	---@param sun number
	init = function(self, width, heigth, water, nutrians, sun)
		for i = 1, heigth, 1 do
			self.map[i] = {}
			for j = 1, width, 1 do
				self.map[j] = self.get_default_value(water, nutrians, sun)
			end
		end
	end,

	---Returns a named tuple with 3 entries
	---@param water number
	---@param nutrians number
	---@param sun number
	get_default_value = function(water, nutrians, sun)
		assert(water > 0 and water <= 100, "water not in percent")
		assert(nutrians > 0 and nutrians <= 100, "nutrians not in percent")
		assert(sun > 0 and sun <= 100, "sun not in percent")
		return { water = water, nutrians = nutrians, sun = sun }
	end
}
