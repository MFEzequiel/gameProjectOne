extends KinematicBody2D

class_name BasicEnemy

export (float) var speed = 30.5
export (float) var gravity = 1500.5
export (float) var timershow = 3.5

export (bool) var move = true

onready var spr = $spr
onready var right = $right
onready var down = $spr/down
onready var timerAnim = $Timer


var vel: Vector2 = Vector2.ZERO


func _ready() -> void:
	timerAnim.wait_time = timershow
	spr.animation = "walk"
	randomize()
	var a = rand_vel()
	

	if vel.x > 0:
		spr.scale.x *= -1
		right.scale.x *= -1


func _right() -> bool:
	return right.is_colliding()


func _down() -> bool:
	return down.is_colliding()


func _physics_process(delta: float) -> void:
	var a = vel.x
#	print(a)
	if move:
		if _right() or !_down():
			vel.x *= -1
		
		if spr.animation == "hit" and spr.frame == 7:
			spr.animation = "hide"
		
		_animation()
		
		if vel.length() > 0:
			vel.normalized() * speed
		
		vel.y += gravity * delta
		vel = move_and_slide(vel)


func _animation():
	if vel.x < 0 and spr.scale.x > 0:
		spr.scale.x *= -1
		right.scale.x *= -1
	elif vel.x > 0 and spr.scale.x < 0:
		spr.scale.x *= -1
		right.scale.x *= -1


func new_animation(anim:String, new_vel:float):
	spr.animation = anim
	vel.x = new_vel
	timerAnim.start()


func kill():
	queue_free()


func _on_Timer_timeout() -> void:
	new_animation("walk", rand_vel())
	timerAnim.stop()



func rand_vel():
	var a = int(rand_range(0,2))
	if a == 0:
		if randf() > speed:
			vel.x = -speed
		else:
			vel.x = speed
	else:
		if randf() < speed:
			vel.x = -speed
		else:
			vel.x = speed
