extends KinematicBody2D

class_name BoardIA 

export (float) var speed = 30
export (float) var gravity = 1500.5

var vel : Vector2 = Vector2.ZERO 
export (bool) var move = true

onready var spr = $spr
onready var timer = $TimerMove
onready var dow = $spr/dow
onready var forward = $forward
onready var forward2 = $forward2

func _ready() -> void:
#	timer.start()
	randomize()
	vel.x -= speed


func _dow() -> bool:
	return dow.is_colliding()

func _forward() -> bool:
	return forward.is_colliding()

func _forward2() -> bool:
	return forward2.is_colliding()


func _process(delta: float) -> void:
	
	if _forward() or !_dow():
		move = false
		move = true
	
	if _forward() and !_forward2():
		move = false
		
		match(randi() % 3):
			0:
				vel.x = 0
				spr.scale.x *= -1
				dow.scale.x *= -1
				forward.scale.x *= -1
				forward2.scale.x *= -1
			1:
				print('for 1')
				vel.y = -320
				if spr.scale.x < 0:
					vel.x = speed
				else:
					vel.x = -speed
			2:
				print('for 2')
				
		
		move = true
	
	animation()
	
	vel.y += gravity * delta
	vel = move_and_slide(vel, Vector2.UP)


func _move():
	match(randi() % 3):
		0:
			vel.x = 0
		1:
			vel.x = speed
			if spr.scale.x > 0:
				spr.scale.x *= -1
				dow.scale.x *= -1
				forward.scale.x *= -1
				forward2.scale.x *= -1
		2:
			vel.x = -speed
			if spr.scale.x < 0:
				spr.scale.x *= -1
				dow.scale.x *= -1
				forward.scale.x *= -1
				forward2.scale.x *= -1


func animation():
	if vel.x != 0:
		spr.animation = "run"
	elif vel.x == 0:
		spr.animation = "idle"


func _on_Timer_timeout() -> void:
	
	if move:
		_move()
