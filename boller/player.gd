extends CharacterBody2D

var estado = "Walk"
var SPEED = 300.0
var JUMP_VELOCITY = -400.0
var stun: bool = false
var ativo: bool = false 

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_accept"):
		$AnimatedSprite2D.play("default")
	
	if stun:
		return
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("run"):
		estado = "Run"
	else:
		estado = "Walk"
	
	if estado == "Walk":
		SPEED = 75
		JUMP_VELOCITY = -285
	elif estado == "Run":
		SPEED = 150
		JUMP_VELOCITY = -305
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if direction == 1:
			$AnimatedSprite2D.flip_h = false
		elif direction == -1:
			$AnimatedSprite2D.flip_h = true
		if estado == "Walk":
			$AnimatedSprite2D.play("walk")
		elif estado == "Run":
			$AnimatedSprite2D.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func AtualizarVida():
	if Player.Vida >= 2:
		$HeartFull2.show()
		$HeartVasio.hide()
	else:
		$HeartFull2.hide()
		$HeartVasio.show()
	if Player.Vida >= 2:
		$HeartFull.show()
		$HeartVasio2.hide()
	else:
		$HeartFull.hide()
		$HeartVasio2.show()

func Dialogo(text: String):
	ativo = !ativo
	if ativo:
		$MeshInstance2D.show()
		$Label.show()
		stun = true
	else:
		$MeshInstance2D.hide()
		$Label.hide()
		stun = false
	$Label.text = text
