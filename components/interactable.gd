extends Node

onready var parent = get_node("..")
onready var global = get_node("/root/global")

export var reach_distance = 50
export var inspect_text = "-missing-"

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
			if(di == null):
				interact()
			else:
				interact_with(di)
	elif(ev.is_action_pressed("right_click")):
		inspect()
		
		
		
func interact():
	print("i")
	if(parent.has_method("interact")):
		parent.interact()

func interact_with(di):
	print(di)
	if(parent.has_method("interact_with")):
		parent.interact_with(di)
		
func inspect():
	print("ins")
	global.get_player().talk(inspect_text)