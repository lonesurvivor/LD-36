extends KinematicBody2D

onready var movement = get_node("movement")

var invincible = 0
var blink = 0
var visible = true

var jumped = false

var life = 100

func _ready():
	set_process(true)
	
func _process(delta):
	handle_input()

	if(movement.state != movement.prev_state):
		get_node("anim").play(movement.state)
		
	if(invincible > 0):
		invincible -= delta
		if(blink > 0):
			blink -= delta
		else:
			visible = !visible
			blink = 0.05
	else:
		invincible = 0
		blink = 0
		visible = true
	get_node("sprite").set_opacity(visible)
	
	#move elsewhere?
	if(has_node("../camera")):
		get_node("../camera").set_pos(get_global_pos())
	
	

func handle_input():
	if(Input.is_action_pressed("ui_left")):
		movement.move(Vector2(-1,0))
		set_scale(Vector2(-1,1))
	elif(Input.is_action_pressed("ui_right")):
		movement.move(Vector2(1,0))
		set_scale(Vector2(1,1))
	else:
		movement.move(Vector2(0,0))
		
	if(Input.is_action_pressed("ui_select")):
		if(!jumped):
			jumped = true
			movement.jump()
	else:
		jumped = false

func hit(by):
	if(invincible == 0):
		movement.knockback(sign(get_pos().x - by.get_pos().x) * 300)
		invincible = 1
		if(by.get("touch_damage")):
			life -= by.touch_damage