local lapis = require("lapis")
local app = lapis.Application()
local respond_to = require("lapis.application").respond_to

--Import Modules
Models = require("models")
User   = require("controllers.user")
Game = require("controllers.game")

--Game Logic
app:match("/game/find", function(self)
	return Game:find(self)
end)

app:match("/game/board", function(self)
	return Game:board(self)
end)

app:match("/game/check", function(self)
	return Game:check(self)
end)

app:moniker("/game/winner", function(self)
	return Game:winner(self)
end)

app:post("/game/pass", function(self)
	if Game:validate(self) == 1 then	
		return Game:pass(self)
	else
		return {json = "fail"}
	end
end)

app:post("/game/new", function(self)
	return Game:new(self)
end)

app:post("/game/move", function(self)
	if Game:validate(self) == 1 then
		return Game:move(self)
	else
		return {json = "fail"}
	end
end)

--User login/register
app:post("/user/login", function(self)
	return User:login(self)
end)
	
app:post("/user/register", function(self)
	return User:register(self)
end)	

app:match("/user/name", function(self)
	return User:headers(headers)
end)

return app
