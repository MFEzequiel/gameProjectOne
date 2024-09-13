extends KinematicBody2D

export (float) var gravity = 2500.0
export (float) var speed = 100
export (float) var hitImpulse = 100
export (float) var jump = -900
export (float) var hp = 100
export (float) var yieldTimer = 0.5
export (float) var coyoteTime = 0.2
export (bool) var move = true
export (String) var resetVect = 'idle'

onready var spr = $spr
onready var jumpTimer = $jump_timer
onready var col = $col
onready var damageCol = $Damaje/col


enum {STATE_IDLE, STATE_WALKING, STATE_JUMP}

var state = STATE_IDLE
var vel = Vector2()
# Coyote time
var jumpBool: bool = false


func _ready() -> void:
	spr.play("idle")
	jumpTimer.wait_time = coyoteTime


func _physics_process(delta: float) -> void:
	
#	print(state)
	
	if move:
	
		if resetVect == 'idle':
			vel.x = 0
		
		move()
		_jump()
		set_new_animation()

		_colEnemy()

		if vel.length() > 0:
			vel.normalized() * speed
		
		vel.y += gravity * delta
		vel = move_and_slide(vel, Vector2.UP)

func move():
	match state:
		STATE_IDLE:
			if resetVect != 'idle':
				state = STATE_WALKING
		STATE_WALKING:
			if resetVect == 'right':
				vel.x = speed
				if damageCol.scale.x < 0:
					damageCol.scale.x *= -1
			elif resetVect == 'left':
				vel.x = -speed
				if damageCol.scale.x > 0:
					damageCol.scale.x *= -1
		STATE_JUMP:
			print(jumpBool)
			if is_on_floor():
				jumpBool = true
			elif jumpBool == true and jumpTimer.is_stopped():
				jumpTimer.start()
			else:
				jumpBool = false
			
			if jumpBool and state == STATE_JUMP:
				vel.y = jump

func _jump():
	if is_on_floor():
		jumpBool = true
	elif jumpBool == true and jumpTimer.is_stopped():
		jumpTimer.start()
	
	if jumpBool and Input.is_action_just_pressed("up"):
		vel.y = jump
		state = STATE_IDLE

func _colEnemy():
	var b: bool = false
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var collider = collision.collider
		var is_stomping = (
			collider.is_in_group("Enemy")
			and collision.normal.is_equal_approx(Vector2.UP)
			and is_on_floor()
		)
		
		var basic_enemy = (collider as BasicEnemy)

		if is_stomping and basic_enemy:
			vel.y = jump
			if basic_enemy.name == 'BasicSnail':
				if basic_enemy.spr.animation != "hide":
					basic_enemy.new_animation("hit", 0.0)
				elif is_stomping and basic_enemy.spr.animation == "hide":
					basic_enemy.vel.x = rand_range(300,-300)

func attack():
	move = false
	damageCol.disabled = true

func set_new_animation():
	if vel.x != 0:
		spr.animation = 'run'
		spr.flip_h = vel.x < 0
	else:
		spr.animation = 'idle'

func _on_jump_timer() -> void:
	jumpBool = false

func bt_jump() -> void:
	state = STATE_JUMP

func _Damaje_body_entered(body: Node) -> void:
	if body.is_in_group("Enemy"):
		if damageCol.scale.x > 0:
			body.vel.x = hitImpulse
			body.spr.animation = "hit"
		else:
			body.vel.x = -hitImpulse
			body.spr.animation = "hit"

#func _on_Button_gui_input(event: InputEvent) -> void:
#	print(event)

func _on_buttonAttack_pressed() -> void:
	attack()
