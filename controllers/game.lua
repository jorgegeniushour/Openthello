local Game = {}
local Board = require("helpers.board")
local db = require("lapis.db")

function Game:find(app)
	local user = User:headers(app.req.headers)
	local games = db.query("select * from game where black=? or white=?", user, user)	
	
	return {json = games}
end

function Game:new(app)
	--Default Game Board	
	local black = User:headers(app.req.headers)
	local white = app.req.params_post.white

        if black == "fail" then
                return {json = "fail"}
        end

	local game = Models.game:create({
		board = Board.default,
		turn  = 0,
		status = 0,
		black = black,
		white = white
	})	

	return {json = game.id}	
end

function Game:board(app)
	local user = User:headers(app.req.headers)
	local game = Models.game:find(app.req.params_post.id)

	if game.black == user or game.white == user then
		return {json = Board:table(game.board)}
	else
		return {json = "fail"}
	end
end

function Game:check(app)
	local game = Models.game:find(app.req.params_post.id)

	if game.status == 2 then
		return {json = "over"}
	end

	if game.turn == 0 then
		if game.black == User:headers(app.req.headers) then
			return {json = "1"}	
		else
			return {json = "0"}
		end	
	elseif game.turn == 1 then
		if game.white == User:headers(app.req.headers) then
			return {json = "1"}	
		else
			return {json = "0"}
		end
	end
end

function Game:validate(app)
	local valid = 1

	--Find game in db
	local game = Models.game:find(app.req.params_post.id)

	local user = User:headers(app.req.headers)
	--Make sure game is being played by correct person
	if game.status ~= 2 then
		--Black	
		if game.turn == 0 then
			if game.black ~= user then
				valid = 0
			end	
		end
		--White
		if game.turn == 1 then
			if game.white ~= user then
				valid = 0
			end			
		end	
	else
		valid = 0
	end

	return valid
end

local function charreplace(string, x, replacement)
	local begin = ""	
	if x > 1 then
		begin = string.sub(string, 1, (x-1))
	end

	local term = ""
	if x < 8 then
		term = string.sub(string, (x+1), 8)
	end

	return begin .. replacement .. term
end

function Game:move(app)
	--Get and interpret game board
	local game  = Models.game:find(app.req.params_post.id)
	local board = Board:table(game.board)

	--Set color and change turn
	local color  = ""	
	if game.turn == 0 then
		color = "black"
		game.turn = 1
	elseif game.turn == 1 then
		color = "white"	
		game.turn = 0
	end

	--Apply move to board
	flip = Board:arrow(
		board, 
		app.req.params_post.x,
		app.req.params_post.y, 
		color
	)

	--Return/apply result
	if flip[1] then
		local piece = ""
		if color == "black" then
			piece = "0"
		else
			piece = "1"
		end
		
		--Flip pieces
		for k, coords in ipairs(flip) do
			board[coords[2]] = charreplace(board[coords[2]], coords[1], piece)
		end
	
		--Place piece on board
		local x = tonumber(app.req.params_post.x)
		local y = tonumber(app.req.params_post.y)	
		board[y] = charreplace(board[y], x, piece)	
	else
		return { json = "fail" }
	end

	--Update in db
	game.board = "" 
	game.status = 0
	game:update("status", "turn", "board")

	return {json = board}
end

function Game:pass(app)
	local game = Models.game:find(app.req.params_post.id)

	game.status = game.status + 1
	game:update("status")	
end

function Game:winner(app)
	local black = 0
	local white = 0

	local game = Models.game:find(app.req.params_post.id)

	for i=1, 64 do
		local piece = string.sub(game.board, i, i)
		if piece == 0 then
			black = black + 1
		elseif piece == 1 then
			white = white + 1
		end
	end

	if black > white then
		return {json = "0"}
	else
		return {json = "1"}
	end
end

return Game
