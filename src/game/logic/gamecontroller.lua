local map = require('src/game/logic/map')

return {
	load = function()
		map.init(5, 4)
	end,

	---get current map table
	---@return map
	get_map = function()
		return map
	end
}
