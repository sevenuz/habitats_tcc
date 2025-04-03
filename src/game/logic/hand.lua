---@class hand
local hand = {}

---is only for the view and is reset after calling needs_redraw()
---@type boolean
hand.redraw = true

---check if it needs a redraw, resets draw state
---@return boolean
function hand.needs_redraw()
	local r = hand.redraw
	hand.redraw = false
	return r
end

---@type card[]
hand.cards = {}

---@param card card
function hand.push(card)
	table.insert(hand.cards, card)
	hand.redraw = true
end

---@param pos number
---@return card
function hand.pop(pos)
	hand.redraw = true
	return table.remove(hand.cards, pos)
end

---execute given fn for all tiles
---@param f function(index: number, card: card)
function hand.for_each(f)
	for i = 1, #hand.cards, 1 do
		f(i, hand.cards[i])
	end
end

return hand
