extends KinematicBody2D

onready var movement = get_node("movement")

var invincible = 0
var blink = 0
var visible = true

var jumped = false

var show_text_duration = 2
var show_text_timer = 0

func _ready():
	set_process(true)
	
func _process(delta):
	handle_input()

	if(movement.state != movement.prev_state):
		get_node("anim").play(movement.state)
	
	if(show_text_timer > 0):
		show_text_timer -= delta
	else:
		if(has_node("talk_box")):
			get_node("talk_box").set_text("")
	
	#move elsewhere?
	if(has_node("../camera")):
		get_node("../camera").set_pos(get_global_pos())
	
	

func handle_input():
	if(Input.is_action_pressed("ui_left")):
		movement.move(Vector2(-1,0))
		get_node("sprite").set_scale(Vector2(-1,1))
		get_node("collision").set_scale(Vector2(-1,1))
	elif(Input.is_action_pressed("ui_right")):
		movement.move(Vector2(1,0))
		get_node("sprite").set_scale(Vector2(1,1))
		get_node("collision").set_scale(Vector2(1,1))
	else:
		movement.move(Vector2(0,0))
		
	
	if(Input.is_action_pressed("ui_down")):
		set_collision_mask_bit(1, false)
		print("u")
	elif(!get_collision_mask_bit(1)):
		print("t")
		set_collision_mask_bit(1, true)
		
	if(Input.is_action_pressed("ui_select")):
		if(!jumped):
			jumped = true
			movement.jump()
	else:
		jumped = false


func talk(text):
	get_node("talk_box").set_text(text)
	show_text_timer = show_text_duration
