extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var dash: bool = false
var canDash: bool = true
var dir: float 
var ss: bool = false                                                           # sentada suprema
var canSS: bool = true
var tocado: bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("left"):
		dir = -1
	elif Input.is_action_just_pressed("right"):
		dir = 1
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("dash"):
		if canDash:
			dash = true
			canDash = false
			$Timer2.start()
	
	if Input.is_action_just_pressed("Magia"):
		if canSS:
			ss = true
			canSS = false
	
	if dash:
		velocity.x = dir * (SPEED * 2)
		velocity.y = 0.0
	
	if ss:
		if not tocado:
			velocity.x = 0.0
			velocity.y  = -800
			tocado = true
		else:
			velocity.x = 0.0
			if is_on_floor():
				tocado = false
				ss = false
				$Timer3.start()
	
	move_and_slide()

func _on_timer_timeout() -> void:
	canDash = true
	$Timer.stop()

func _on_timer_2_timeout() -> void:
	dash = false
	$Timer.start()
	$Timer2.stop()

func _on_timer_3_timeout() -> void:
	canSS = true
	$Timer3.stop()
