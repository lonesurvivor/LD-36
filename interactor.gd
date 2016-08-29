extends Node

onready var global = get_node("/root/global")



var interactor1
var interactor2
var world

func _ready():
	randomize()
	
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
	
func remove_from_inv(name):
	if(in_inventory(name)):
		global.remove_item_by_name(name)
		
func remove_from_world(name):
	by_name(name).get_node("item").remove_from_world()
	
func player_talk(text):
	global.get_player().talk(text)
	
func instantiate_and_add(name):
	var i =  ResourceLoader.load("res://items/" + name + "/" + name + ".tscn").instance()
	global.add_item(i)
	
# all the interactive stuff here

# global variables
var door_fueled = 0
var door_watered = 0
var door_pipe_repaired = 0
var door_gear_repaired = false

func inspect_in_inventory(i1):
	interactor1 = i1
	interactor2 = null
	
	var name = i1.get_name()

	if(name == "sunflowers"):
		player_talk("Let's get the seeds out!")
		remove_from_inv("sunflowers")
		instantiate_and_add("sunflower_seeds")
		
	else:
		player_talk(i1.get_node("interactable").inspect_text)
		
	
		

# the first one i1 is ALWAYS the one that can be in inventory or world
func interact(i1, i2, on_world):
	interactor1 = i1
	interactor2 = i2
	world = on_world
	
			
	# gear part
			
	if check_match("sand", "oven"):
		player_talk("That's a nice bottle.")
		remove_from_inv("sand")
		instantiate_and_add("empty_bottle")
		global.play_sound("oven")
			
	elif check_match("sunflower_seeds", "work_bench"):
		player_talk("I need something to store the oil in")
			
	elif(check_match("sunflower_seeds", "empty_bottle")):
		player_talk("That should work.")
		remove_from_inv("sunflower_seeds")
		remove_from_inv("empty_bottle")
		instantiate_and_add("bottle_with_seeds")
		
	elif(check_match("bottle_with_seeds", "work_bench")):
		player_talk("let's crush them!")
		remove_from_inv("bottle_with_seeds")
		instantiate_and_add("oil")
		
	elif(check_match("oil", "elder_robot")):
		remove_from_inv("oil")
		instantiate_and_add("metal_plate")
		player_talk("Here, i got some oil for you!")
		by_name("elder_robot").get_node("interactable").talk("Tha *krr* *krr* y *krr*. Ta *krr* th *krr*")
		by_name("elder_robot").give_oil()
		
	elif(check_match("metal_plate", "saw")):
		remove_from_inv("metal_plate")
		remove_from_inv("saw")
		instantiate_and_add("plate_and_saw")
		player_talk("If this will work?")
		
	elif(check_match("plate_and_saw", "work_bench")):
		remove_from_inv("plate_and_saw")
		instantiate_and_add("saw")
		instantiate_and_add("metal_gear")
		player_talk("There we go.")
		
		
	# steam part
	
	elif(interactor1.get_name().substr(0,4) == "tree" and interactor2.get_name() == "axe"):
		instantiate_and_add("wood")
		player_talk("Chop choppy chop!")
		
	elif(check_match("wood", "oven")):
		remove_from_inv("wood")
		instantiate_and_add("charcoal")
		player_talk("Charcoal is way better than raw wood.")
		global.play_sound("oven")
		
		
	elif(check_match("empty_bottle", "water")):
		remove_from_inv("empty_bottle")
		instantiate_and_add("bottle_with_water")
		player_talk("Filled!")
		
		
	elif(check_match("saw", "copper_pipe")):
		if(on_world("copper_pipe")):
			add_to_inv("copper_pipe")
			remove_from_world("copper_pipe")
			player_talk("You can always use a piece of pipe!")
			
			
	# door part
	elif(check_match("bottle_with_water", "door_oven")):
		remove_from_inv("bottle_with_water")
		door_watered = 2
		by_name("door_oven").update(door_watered + door_fueled + door_pipe_repaired)
		player_talk("May there be steam!")

	elif(check_match("charcoal", "door_oven")):
		remove_from_inv("charcoal")
		door_fueled = 1
		by_name("door_oven").update(door_watered + door_fueled + door_pipe_repaired)
		player_talk("It's burning!")
		
	elif(check_match("copper_pipe", "door_oven")):
		remove_from_inv("copper_pipe")
		door_pipe_repaired = 4
		by_name("door_oven").update(door_watered + door_fueled + door_pipe_repaired)
		player_talk("I knew that would be useful!")
		
	elif(check_match("metal_gear", "door_mechanics")):
		remove_from_inv("metal_gear")
		by_name("door_mechanics").insert_gear()
		door_gear_repaired = true
		player_talk("Fits perfectly!")
		
	elif(check_match("key", "outside_door")):
		if(door_watered && door_fueled && door_pipe_repaired && door_gear_repaired):
			remove_from_inv("key")
			by_name("outside_door").open()
			player_talk("Yes! I did it!")
		else:
			player_talk("Nothing happened. Maybe there is something broken?")
			
			
			
	# special deny cases
	elif(interactor1.get_name().substr(0,4) == "tree" and interactor2.get_name() == "saw"):
		player_talk("That would take forever.")
	elif(check_match("wood", "door_oven")):
		player_talk("Raw wood isn't powerful enough for this engine. We need coal.")
	
	else:
		global.play_sound("deny")
		var text = ["That doesn't work.", "That doesn't make sense.", "Really?", "I don't want to do that.", "ERROR 587: No possible interaction"]
		var r = randi() % text.size()
		player_talk(text[r])


	global.set_drag_item(null)
