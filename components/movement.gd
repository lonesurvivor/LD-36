extends Node

export var speed = 80
export var jump_speed = 220
export var can_fly = false

var gravity = 10
var max_vertical_speed = 400
var ceiling_bounce_factor = 3

var prev_state = "idle"
var state = "idle"
var next_state = "idle" setget set_next_state
func set_next_state(state):
	if(next_state == self.state):
		next_state = state
		
#input cache
var move_input = Vector2(0,0) setget move
func move(direction):
	move_input = direction
	
func stop():
	move_input = Vector2(0,0)
	
var start_jump = false setget jump
func jump():
	if(on_ground): start_jump = true
	
var knockback = 0 setget knockback
func knockback(direction): knockback = direction
	

var vertical_speed = 0

var on_ground = false

onready var parent = get_parent()

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	prev_state = state
	state = next_state
	
	on_ground = parent.test_move(Vector2(0,0.5))
	
	_do_move(delta)
	
	if(state == "idle"):
		idle_state(delta)
	elif(state == "move"):
		move_state(delta)
	elif(state == "jump"):
		jump_state(delta)
		
		
func idle_state(delta):
	if(!on_ground):
		set_next_state("jump")
	elif(move_input.length() > 0.001):
		set_next_state("move")
	
func move_state(delta):
	if(!on_ground):
		set_next_state("jump")
	elif(move_input.length() < 0.001):
		set_next_state ("idle")
	
func jump_state(delta):
	if(on_ground):
		if(move_input.length() > 0.001):
			set_next_state("move")
		else:
			set_next_state("idle")
			
func _do_move(delta):
	var by = Vector2(0,0)

	if(knockback == 0):
		by.x = move_input.x * delta * speed
	else:
		by.x = delta * knockback
		knockback /= 1.3
		if(abs(knockback) < 50.0):
			knockback = 0
	
	
	if(!can_fly):
		if(!on_ground):
			if(parent.test_move(Vector2(0,-1))):
				vertical_speed = gravity*ceiling_bounce_factor
			else:
				vertical_speed += gravity
			
			vertical_speed = min(vertical_speed,max_vertical_speed)
		elif(start_jump):
			vertical_speed = -jump_speed
			start_jump = false
		else:
			vertical_speed = 0
			
		by.y = delta * vertical_speed
	else:
		by.y = move_input.y * delta * speed
		
	parent.move(by)
	
	if(parent.is_colliding() ):
		var n = parent.get_collision_normal()
		var slide = n.slide(by)
		parent.move(slide)