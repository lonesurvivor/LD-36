extends Node

onready var global = get_node("/root/global")

func _ready():
	pass

func _on_start_pressed():
	global.load_scene("house")
	
	
