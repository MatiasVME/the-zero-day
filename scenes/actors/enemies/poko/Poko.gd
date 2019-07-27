extends "res://scenes/actors/enemies/GEnemy.gd"

onready var max_speed = 50
onready var speed = Vector2(0,0)
onready var acceleration = 50
onready var move_dir = rand_range(0,360)
onready var is_waiting = false
onready var objective = null

func _ready():
	state = State.RANDOM_WALK
	$TimerWalk.start()
	
func _physics_process(delta):
	if speed.x > 0: $Sprite.flip_h = true
	if speed.x < 0: $Sprite.flip_h = false
	
	match state:
		State.SEEKER:
			if is_waiting == false:
				if objective != null:
					var delta_x = global_position.x-objective.global_position.x
					var delta_y = global_position.y-objective.global_position.y
					
					speed.x = -delta_x/acceleration*2
					speed.y = -delta_y/acceleration*2
					
			
				move_and_slide(speed*acceleration)
			
		State.RANDOM_WALK:
			if is_waiting == false:
				speed.x = cos(deg2rad(move_dir))
				speed.y = sin(deg2rad(move_dir))
				move_and_slide(speed*acceleration)

func _on_TimerWalk_timeout():
	is_waiting = true
	$TimerWait.start()
	$TimerWalk.stop()

func _on_TimerWait_timeout():
	is_waiting = false
	move_dir = rand_range(0,360)
	$TimerWalk.start()
	$TimerWait.stop()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		state = State.SEEKER
		objective = body
	

func _on_DetectArea_body_exited(body):
	if body.is_in_group("Player"):
		state = State.RANDOM_WALK
		objective = null