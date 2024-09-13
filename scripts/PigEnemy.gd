extends KinematicBody2D

class_name Pig

export (float) var speed = 40.5
export (float) var gravity = 1500.5
export (float) var newMove = 2.5
export (bool) var move = true

onready var spr = $spr
onready var lab = $Label
onready var down = $spr/down
onready var right = $right
onready var detect = $detect
onready var callFunc = $newMove
onready var player = get_node("//root/MainScene/player")

var vel = Vector2()
var n = 0



func _ready() -> void:
	
	spr.animation = 'idle'
	vel.x = rand_range(speed, -speed)
	
	callFunc.wait_time = newMove
	callFunc.start()


func down() -> bool:
	return down.is_colliding()

func right() -> bool:
	return right.is_colliding()

func _detect() -> bool:
	return detect.is_colliding()

func _process(delta: float) -> void:
	
	if _detect():
		move = false
		spr.animation = "run"
		if detect.scale.x > 0:
			speed = 80
			vel.x = -speed
		else:
			speed = 80
			vel.x = speed
	else:
		speed = 40
		move = true

	if right() or !down():
		vel.x = 0
		spr.animation = 'idle'
		spr.scale.x *= -1
		detect.scale.x *= -1
		right.scale.x *= -1
		move = false
		move = true
	
	lab.text = str(speed)
	
	vel.y += gravity * delta
	vel = move_and_slide(vel)


func _try_move():
	if (rand_range(0,1.1) < 0.8):
		_move()


func _move():
	match(randi() % 3):
		0:
			spr.animation = "idle"
		1:
			spr.animation = "walk"
			vel.x = speed
			if spr.scale.x > 0:
				spr.scale.x *= -1
				detect.scale.x *= -1
				right.scale.x *= -1
		2:
			spr.animation = "walk"
			vel.x = -speed
			if spr.scale.x < 0:
				spr.scale.x *= -1
				detect.scale.x *= -1
				right.scale.x *= -1


func _on_newMove_timeout() -> void:
	
	if move:
		n += 1 
		_try_move()
