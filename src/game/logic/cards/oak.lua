---@class card
local card = {}

---@type string
card.name = "Oak Tree"
---@type string
card.text = "Grows under right conditions, dies under wrong conditions."
---@type string
card.image = "sprites/oak.png"
---@type number
card.energy = 1
---@type element
card.elements = { water = 65, nutrians = 80, sun = 50 }
---@type number
card.attack = 2
---@type number
card.life = 3
---Wether can be played as first card or not. If so, it is the plant of life.
---@type boolean
card.is_first = true

function from_deck_to_shop() end
function from_shop_to_hand() end
function from_hand_to_map() end
function from_map_to_deck() end

return card
