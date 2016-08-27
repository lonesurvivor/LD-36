extends Node

onready var parent = get_node("..")
onready var global = get_node("/root/global")
onready var interactor = get_node("/root/interactor")

export var reach_distance = 50
export var inspect_text = "-missing-"

var show_text_duration = 2
var show_text_timer = 0

var first = true
func _ready():
	if(first):
		if(parent.has_node("click_box")):
			parent.get_node("click_box").connect("input_event", self, "_on_input")
		first = false
	set_process(true)
	
	
func _process(delta):
	if(show_text_timer > 0):
		show_text_timer -= delta
	else:
		if(parent.has_node("talk_box")):
			parent.get_node("talk_box").set_text("")

func _on_input(ev):
	if(ev.type == InputEvent.MOUSE_BUTTON):
		if(ev.is_action_pressed("click")):
			if((global.get_player().get_pos() - parent.get_pos()).length() < reach_distance):
				var di = global.get_drag_item()
				if(di == null):
					interact()
				else:
					interact_with(di, true)
			else:
				global.get_player().talk("i can't reach it!")
		elif(ev.is_action_pressed("right_click")):
			inspect()
		
		
		
func interact():
	if(parent.has_method("interact")):
		parent.interact()
	elif(parent.has_node("item")):
		parent.get_node("item").interact()

func interact_with(other, on_world = false):
	if(parent.has_method("interact_with")):
		parent.interact_with(other, on_world)
	else:
		interactor.interact(parent, other, on_world)
		
func inspect():
	global.get_player().talk(inspect_text)
	

func talk(text):
	if(parent.has_node("talk_box")):
		parent.get_node("talk_box").set_text(text)
		show_text_timer = show_text_duration