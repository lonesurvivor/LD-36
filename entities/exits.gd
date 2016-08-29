extends Node

onready var global = get_node("/root/global")

var disabled = 0
var new = true

func _ready():
	if(new):
		set_process(true)
		for i in get_children():
			i.connect("body_enter", self, "_on_body_enter", [i.get_name()])
		new = false
		
func _process(delta):
	if(disabled > 0):
		disabled -= delta

func _on_enter_tree():
	disabled = 0.1
	var last = get_node("/root/global").last_scene_id
	if(has_node(last + "/entry_position")):
		get_node("/root/global").get_player().set_pos(get_node(last + "/entry_position").get_global_pos())


func _on_exit_tree():
	pass

func _on_body_enter(body, from):
	if(disabled <= 0):
		var target_scene = from
		if(body.get_name() == "player"):
				if(target_scene == "outside"):
					get_tree().change_scene("res://scenes/outside.tscn")
				else:
					global.load_scene(target_scene)