extends Node

onready var parent = get_node("..")
onready var global = get_node("/root/global")

onready var name = parent.get_name()

export(Texture) var inventory_texture
export(float) var reach_distance = 50 
export(bool) var stays_in_world = false

export var inspect_in_inventory_text = "-missing-"

export(bool) var cant_taken = false

func interact():
	var di = global.get_drag_item()
	if(di == null && !cant_taken):
		global.add_item(parent)
		if(!stays_in_world):
			remove_from_world()
	
func remove_from_world():
	if(parent.has_node("..")):
		parent.get_node("..").remove_child(parent)
	
	
