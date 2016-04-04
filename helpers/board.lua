local Board = {}

Board.default = "eeeeeeeeeeeeeeeeeeeeeeeeeee01eeeeee10eeeeeeeeeeeeeeeeeeeeeeeeeee"

--Creates a table rep. of board out of a string
function Board:table(input)
	local board = {}
	for i = 1, 8 do
		--Find start and end posititon
		local start     = ((i - 1) * 8) + 1
		local terminate = start + 7
	
		--Push row to matrix
		local row = string.sub(input, start, terminate)
		table.insert(board, row)
	end

	return board
end

--Accepts board as table and flips pieces or detects bad move
local directions = {
	{0, 1},
	{8, 1},
	{8, 0},
	{8, 8},
	{0, 8},
	{1, 8},
	{1, 0},
	{1, 1}
}

function Board:arrow(board, x, y, color)
	local flip = false	
	local toflip = {}
	local velX, velY = 0

	--Send an arrow in each direction	
	for direction, limit in ipairs(directions) do
		--Shoot until unflippable
		local shot = false
	
		--Set arrow X velocity		
		if limit[1] == 1 then
	   		velX = -1
		elseif limit[1] == 8 then
			velX = 1
		else	
			velX = 0
		end

		--Set arrow Y velocity
		if limit[2] == 1 then
			velY = -1
		elseif limit[2] == 8 then
			velY = 1	
		else
			velY = 0
		end

		--Shoot until limit is reached 
		local curX = x
		local curY = y
		local flipPassed = false	
		local passed = {}
		
		while curX ~= limit[1] and curY ~= limit[2] do
			--Move Cursor	
			curX = curX + velX
			curY = curY + velY	
	
			--Check piece at cursor
			local piece = string.sub(board[curY], curX, curX)
			if piece == "0" and color == "black" then
				flipPassed = true
				break
			elseif piece == "1" and color == "white" then
				flipPassed = true
				break
			elseif piece == "e" then	
				break
			else
				table.insert(passed, {curX, curY})	
			end
		end

		if flipPassed then
			--Put each flip in toflip
			for k, coords in ipairs(passed) do
				table.insert(toflip, coords)
			end	

			flip = true
		end	
	end

	return toflip
end

return Board
