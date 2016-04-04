local Token = {}

local config = require("lapis.config").get()
local jwt = require("luajwt")
local key = config.secret 

function Token:create(user)
	--Create JWT	
	local payload = {
		iss     = "official api",
		nbf     = os.time(),
		typ     = "access",
		user_id = user	
	}

	local alg = "HS256"
	local access, err = jwt.encode(payload, key, alg)	

	--Return Tokens
	tokens = {
		['access'] = access,
	}

	return tokens
end

function Token:decode(token)
	local validate = true
	local decoded, err = jwt.decode(token, key, validate)

	return decoded
end

function Token:refresh(refresh)
	--Decode Refresh Token
	local decoded = Token:decode(refresh)

	if decoded ~= nil then
		return Token:create(decoded.user_id)
	end

	return "expired"
end

return Token
