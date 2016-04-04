local Model = require("lapis.db.model").Model
local Models = {}

Models.user = Model:extend("users", {
	primary_key = "name"
})

Models.game = Model:extend("game", {
    primary_key = "id"
})

return Models
