import request as req

#States
def login(action):
	while True:
		#Get Input
		name   = raw_input("Username: ")
		passwd = raw_input("Password: ")

		#Send Req
		try:	
			if action == "l":
				token = req.login(name, passwd)
			elif action == "r":
				token = req.register(name, passwd)
			return name, token	
		except TypeError:
			print("Whoops! Looks like you messed up your info.") 
		'''	
		#Check Login Res	
		if token and token != "fail":
			return name, token
		'''
def play(id):
	#Print Board
	board = req.board(token, id)

	print("12345678")

	i = 0
	for row in board:
		i +=1
		print(row + " " + str(i))	

	#Move
	moved = False
	while not moved:
		#Get Coord Inputs
		x = raw_input("X Coordinate: ")
		y = raw_input("Y Coordinate: ")

		#Send Req
		res = req.move(token, id, x, y)
		if type(res) is str:
			print("fail")
		else:
			moved = True
def new():
	#Create new game
	opponent = raw_input("Enter username of opponent: ")
	id = req.new_game(token, opponent)			
	play(id)

def menu():
	games = req.menu(token)

	#Print Chart
	print("id     black      white      turn")
	
	#Loop To turn Res into interface
	for i in games:
		space = "     "

		#Check whose turn it is
		if i["turn"] == 0:
			turn = "black"
		else:
			turn = "white"

		#Create List of Games	
		msg = str(i["id"])
		msg +=space
		msg += str(i["black"])
		msg +=space
		msg += str(i["white"])
		msg +=space
		msg += turn
		msg +=space		

		print(msg)
	
	#Show Command Prompts
	id = raw_input("Select game to play or [c]ancel\n")	

	if id != "c":	
		play(id)


if __name__ == "__main__":
	print("Openthello")
	
	#See if user wants to login or register
	action = raw_input("[l]ogin or [r]egister\n")	
	name, token = login(action)
	
	#Menu Loop
	running = True
	while running:
		#Select which action to take
		action = raw_input("[n]ew game or [r]esume game\n")
	
		if action == "r":	
			menu()
		elif action == "n":
			new()
		else:
			menu()
