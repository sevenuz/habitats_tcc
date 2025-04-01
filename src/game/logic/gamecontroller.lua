local map = require('src/game/logic/map')

return {
	load = function()
		map.init(map, 5, 4)
	end,

	---get current map table
	---@return table
	get_map = function()
		return map
	end
}
