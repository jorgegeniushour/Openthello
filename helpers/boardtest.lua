print("3, 5")
print("")

local Board = require("board")
board = Board:table("eeeeeeeeeeeee0000eeeeeee11101eeeeee10eeeeeeeeeeeeeeeeeeeeeeeeeee")

print("Board: ")
print("12345678")

for k,v in ipairs(board) do
	print(v .. " " .. k)
end
print("")

flips = Board:arrow(board, 3, 5, "black")
print("To Flip: ")
if flips[1] then 
for k, v in ipairs(flips) do
	print(v[1], v[2])
end
else
	print("fail")
end
