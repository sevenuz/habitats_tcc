---@class hand
local hand = {}

---@type card[]
hand.cards = {}

---@param card card
function hand.push(card)
	table.insert(hand.cards, card)
end

---@param pos number
---@return card
function hand.pop(pos)
	return table.remove(hand.cards, pos)
end

---execute given fn for all tiles
---@param f function(card: card)
function hand.for_each(f)
	for i = 1, #hand.cards, 1 do
		f(hand.cards[i])
	end
end

return hand
