import unirest
import json

#App Config
url = ""

#Custom Reqs
def login(name, password):
	params = {"name": name, "password": password}
	response = unirest.post((url + "/user/login"), params=params)

	return response.body["access"]

def register(name, password):
	params = {"name": name, "password": password}
	response = unirest.post((url + "/user/register"), params=params)

	return response.body["access"]

def new_game(access, opponent):
	params = {"access": access, "white": opponent}
	response = unirest.post((url + "/game/new"), params=params)

	return response.body	

def menu(access):
	params = {"access": access}
	response = unirest.post((url + "/game/find"), params=params)

	return response.body

def board(access, id):
	params = {"access": access, "id": id}
	response = unirest.post((url + "/game/board"), params=params)

	return response.body

def move(access, id, x, y):
	params = {"access": access, "id": id, "x": x, "y": y}	
	response = unirest.post((url + "/game/move"), params=params)

	return response.body
