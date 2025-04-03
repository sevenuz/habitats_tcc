local map = require('src/game/logic/map')
local deck = require('src/game/logic/deck')
local hand = require('src/game/logic/hand')
local shop = require('src/game/logic/shop')

-- TODO after deck builder and deck chooser exist, remove this
local card_sun = require('src/game/logic/cards/sun')
local card_water = require('src/game/logic/cards/water')
local card_nutrians = require('src/game/logic/cards/nutrians')
local card_oak = require('src/game/logic/cards/oak')
local cards = { card_oak, card_sun, card_nutrians, card_water }

-- example deck with 16 cards
local function example_deck()
	for j = 1, 16, 1 do
		deck.cards[j] = util.deepcopy(cards[(j % #cards) + 1])
		-- normally move deck.start_hand to hand.cards
		hand.cards = cards
		-- normally move deck.cards first cards shop.cards
		if j < 4 then
			shop.cards[j] = util.deepcopy(cards[(j % #cards) + 1])
		end
	end
end
-- TODO DELETE until here

return {
	load = function()
		map.init(5, 4)
		example_deck()
	end,

	---@return map
	get_map = function()
		return map
	end,

	---@return hand
	get_hand = function()
		return hand
	end,

	---@return shop
	get_shop = function()
		return shop
	end,


	---@return deck
	get_deck = function()
		return deck
	end,
}
