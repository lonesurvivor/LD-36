extends Node

onready var global = get_node("/root/global")

var interactor1
var interactor2
var world

func _ready():
	pass
	
func check_match(name1, name2):
	return ( (interactor1.get_name() == name1 and interactor2.get_name() == name2) or (interactor1.get_name() == name2 and interactor2.get_name() == name1))


func by_name(name):
	if(name == interactor1.get_name()):
		return interactor1
	elif(name == interactor2.get_name()):
		return interactor2

func in_inventory(name):
	return global.has_item(by_name(name))
	
func on_world(name):
	return (by_name(name) == interactor1 and world == true)
	
func add_to_inv(name):
	global.add_item(by_name(name))
	
func add_new_to_inv(name):
	pass
	
func remove_from_inv(name):
	if(in_inventory(name)):
		global.remove_item_by_name(name)
		
func remove_from_world(name):
	by_name(name).get_node("item").remove_from_world()
	
func player_talk(text):
	global.get_player().talk(text)
	
# all the interactive stuff here
# the first one i1 is ALWAYS the one that can be in inventory or world
func interact(i1, i2, on_world):
	interactor1 = i1
	interactor2 = i2
	world = on_world
	
	if(check_match("wood", "axe")):
		if(in_inventory("axe")):
			if(on_world("wood")):
				add_to_inv("wood")
				#remove_from_world("wood")
				player_talk("made some logs!")
			else:
				player_talk("aaa")
		else:
			player_talk("i should'nt break down the axe with the tree")
			
	elif(check_match("wood", "robot")):
		player_talk("robots dont like wood")


	global.set_drag_item(null)
