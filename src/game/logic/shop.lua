---@class shop
local shop = {}

---is only for the view and is reset after calling needs_redraw()
---@type boolean
shop.redraw = true

---check if it needs a redraw, resets draw state
---@return boolean
function shop.needs_redraw()
	local r = shop.redraw
	shop.redraw = false
	return r
end

---@type card[]
shop.cards = {}

---@param card card
function shop.push(card)
	table.insert(shop.cards, card)
	shop.redraw = true
end

---@param pos number
---@return card
function shop.pop(pos)
	shop.redraw = true
	return table.remove(shop.cards, pos)
end

---execute given fn for all tiles
---@param f function(index: number, card: card)
function shop.for_each(f)
	for i = 1, #shop.cards, 1 do
		f(i, shop.cards[i])
	end
end

return shop
