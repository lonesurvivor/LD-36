extends Node

onready var parent = get_node("..")
onready var global = get_node("/root/global")

onready var name = parent.get_name()

export(Texture) var inventory_texture

var first = true
func _ready():
	if(first):
		if(parent.has_node("click_box")):
			parent.get_node("click_box").connect("input_event", self, "_on_input")
		first = false
		
		
func _on_input(ev):
	if(ev.is_action_pressed("click")):
		if((global.get_player().get_pos() - parent.get_pos()).length() < 50):
			global.add_item(name, parent)
			parent.get_node("..").remove_child(parent)


