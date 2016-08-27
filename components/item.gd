extends Node

onready var parent = get_node("..")
onready var global = get_node("/root/global")

onready var name = parent.get_name()

export(Texture) var inventory_texture
export(float) var reach_distance = 50 

export var inspect_in_world_text = "-missing-"
export var inspect_in_inventory_text = "-missing-"

export(bool) var is_placeable = false
export(bool) var is_takeable = true


var first = true
func _ready():
	if(first):
		if(parent.has_node("click_box")):
			parent.get_node("click_box").connect("input_event", self, "_on_input")
		first = false
		
		
func _on_input(ev):
	if(ev.is_action_pressed("click")):
		if((global.get_player().get_pos() - parent.get_pos()).length() < reach_distance):
			var di = global.get_drag_item()
			if(di == null and is_takeable):
				global.add_item(name, parent)
				parent.get_node("..").remove_child(parent)
			else:
				interact_with(di)
	elif(ev.is_action_pressed("right_click")):
		inspect_in_world()


func inspect_in_world():
	global.get_player().talk(inspect_in_world_text)
	
func inspect_in_inventory():
	global.get_player().talk(inspect_in_inventory_text)
	
func interact_with(other):
	if(parent.has_method("interact_with")):
		parent.interact_with(other)