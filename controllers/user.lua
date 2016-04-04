local crypt  = require("lsha2")
local Token  = require("helpers.token")
local Models = require("models")

local User = {}

--Use /dev/random to create a random value
local function ranval()
        local frandom = assert(io.open("/dev/urandom", "rb"))
        local s = frandom:read(4)
        assert(s:len() == 4)
        local v = 0
        for i = 1, 4 do
                v = 256 * v + s:byte(i)
        end
        return v
end

--Identify user from access token
function User:headers(headers)
	if headers.access then
		--Try to id user
		local user = User:identify(headers.access)
		
		--Id failed	
		if user == "fail" then
			return "fail"		
		end

		return user
	end

	return "fail"
end

--Get information from tokens
function User:identify(access)
	local decoded = Token:decode(access)

	if decoded ~= nil then	
		if decoded.typ == "access" then
			return decoded.user_id
		end
	end
	
	return "fail"
end

--Create new access token from credentials
function User:login(app)
	local username = app.req.params_post.name
	local password = app.req.params_post.password
	local response = Models.user:find(username)

	if not response then
		return { json = "fail" }
	end

	--Hash input
	local password = password .. response.salt
	password = crypt.hash256(password)

	--Compare Hashes
	if response.hash == password then
		return { json = Token:create(username) }
	end

	return { json = "fail" }
end

function User:register(app)
	local username = app.req.params_post.name
	local password = app.req.params_post.password	
	--Make sure name isn't taken
	local response = Models.user:find(username)
	if response then
		return { json = "fail" }
	end

	--Salt Password
	local salt = ranval()
	password = password .. salt

	--Hash it!
	local hash = crypt.hash256(password)

	--Create User Model
	local user = Models.user:create({
		name = username,
		hash = hash,
		salt = salt
	})

	--Return tokens for new user
	local tokens = Token:create(username)
	return { json = tokens}
end

return User
