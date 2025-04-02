---@class deck
local deck = {}

---@type card[]
deck.cards = {}

---these cards are pushed into hand at the beginning of the game
---@type card[]
deck.start_hand = {}

---start tile elements are the same for players side
---@type element
deck.element = { water = 50, nutrians = 50, sun = 50 }

---@param card card
function deck.push_to_bottom(card)
	table.insert(deck.cards, card, 1)
end

---@param pos number
---@return card
function deck.pop(pos)
	return table.remove(deck.cards, pos)
end

---execute given fn for all tiles
---@param f function(card: card)
function deck.for_each(f)
	for i = 1, #deck.cards, 1 do
		f(deck.cards[i])
	end
end

return deck
