extends Node

onready var root = get_tree().get_root()

onready var ui = preload("res://ui.tscn").instance()
onready var player = preload("res://entities/player.tscn").instance()
onready var sound = null

var scenes_resource = {}
var scenes = {}
var current_scene = null
var current_scene_id = null
var last_scene_id = ""

var inventory = {}

var drag_item = null setget set_drag_item,get_drag_item
func set_drag_item(item):
	drag_item = item
func get_drag_item():
	return drag_item


func _ready():
	current_scene = root.get_child( root.get_child_count() -1 )
	current_scene_id = "main"
	
	# load all 
	scenes_resource["house"] = ResourceLoader.load("res://scenes/house.tscn")
	scenes_resource["village"] = ResourceLoader.load("res://scenes/village.tscn")
	
	
	for i in scenes_resource:
		scenes[i] = scenes_resource[i].instance()
		
	last_scene_id = "main"
	scenes["main"] = current_scene
	
	sound = SamplePlayer.new()
	sound.set_sample_library(load("res://sounds/samples.tres"))



# scenes


func load_scene(id):
	call_deferred("_load_scene",id)
	
func _load_scene(id):
	last_scene_id = current_scene_id
	current_scene.remove_child(player)
	current_scene.remove_child(ui)
	root.remove_child(current_scene)
	
	
	current_scene = scenes[id]
	
	current_scene.add_child(ui)
	current_scene.add_child(player)
	root.add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	current_scene_id = id
	
	
# inventory

func has_item(item):
	return inventory.has(item.get_name())

func add_item(item):
	inventory[item.get_name()] = item
	ui.update()
	sound.play("pickup")
	
func remove_item_by_name(name):
	inventory.erase(name)
	ui.update()
	
func remove_item(item):
	inventory.erase(item.get_name())
	ui.update()

func get_items():
	return inventory
	
func get_player():
	return player
	
var sound_enabled = true
func enable_sound(e):
	sound_enabled = e
	
func play_sound(name):
	if(!sound.is_active()):
		if(sound_enabled):
			sound.play(name)

		