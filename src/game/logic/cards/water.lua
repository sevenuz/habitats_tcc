---@class card
local card = {}

---@type string
card.name = "Water"
---@type string
card.text = "Increases water of the field by 20%"
---@type string
card.image = "sprites/water.png"
---@type number
card.energy = 1
---@type element
card.elements = { water = 0, nutrians = 0, sun = 0 }
---@type number
card.attack = 0
---@type number
card.life = 0
---Wether can be played as first card or not. If so, it is the plant of life.
---@type boolean
card.is_first = false

function from_deck_to_shop() end
function from_shop_to_hand() end
function from_hand_to_map() end
function from_map_to_deck() end

return card
