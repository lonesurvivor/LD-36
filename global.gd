extends Node

onready var root = get_tree().get_root()

onready var ui = preload("res://ui.tscn").instance()
onready var player = preload("res://entities/player.tscn").instance()

var scenes_resource = {}
var scenes = {}
var current_scene = null
var current_scene_id = null
var last_scene_id = ""

var inventory = {}


func _ready():
	current_scene = root.get_child( root.get_child_count() -1 )
	current_scene_id = "main"
	
	# load all 
	scenes_resource["test"] = ResourceLoader.load("res://scenes/test.tscn")
	
	
	for i in scenes_resource:
		scenes[i] = scenes_resource[i].instance()
		
	scenes["main"] = current_scene
	
	current_scene.add_child(ui)
	current_scene.add_child(player)


func load_scene(id):
	call_deferred("_load_scene",id)
	
func _load_scene(id):
	last_scene_id = current_scene_id
	current_scene.remove_child(player)
	current_scene.remove_child(ui)
	root.remove_child(current_scene)
	
	
	current_scene = scenes[id]
	
	current_scene.add_child(player)
	current_scene.add_child(ui)
	root.add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	current_scene_id = id
	


func add_item(name, item):
	inventory[name] = item
	ui.update()
	
func remove_item(name):
	inventory.erase(name)
	ui.update()

func get_items():
	return inventory
	
func get_player():
	return player