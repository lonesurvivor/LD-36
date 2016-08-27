extends Node

onready var parent = get_node("..")
onready var global = get_node("/root/global")
onready var interactor = get_node("/root/interactor")

onready var name = parent.get_name()

export(Texture) var inventory_texture
export(float) var reach_distance = 50 

export var inspect_in_inventory_text = "-missing-"

export(bool) var is_placeable = false

func interact():
	var di = global.get_drag_item()
	if(di == null):
		global.add_item(parent)
		remove_from_world()
		
func interact_with(other, on_world):
	interactor.interact(parent, other, on_world)
	
func inspect_in_inventory():
	global.get_player().talk(inspect_in_inventory_text)
	
func remove_from_world():
	if(parent.has_node("..")):
		parent.get_node("..").remove_child(parent)
	
	
