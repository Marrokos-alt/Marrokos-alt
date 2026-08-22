extends CharacterBody3D

@export var sensibilidade: float = 0.005
@export var SPEED = 5.0
const JUMP_VELOCITY = 4.5
var nascer:  bool = true
var Vida: float = 100
var knockback: Vector3
var forcaK: float = 5.0
var atrito: float = 20.0
var inimigos = []

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Timer.start()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * sensibilidade
		$Pivo.rotation.x -= event.relative.y * sensibilidade
		$Pivo.rotation.x = clamp($Pivo.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _process(delta: float) -> void:
	$CanvasLayer/ProgressBar.value = Vida
	
	if nascer:
		$CanvasLayer/MeshInstance2D.self_modulate.a -= delta
		if $CanvasLayer/MeshInstance2D.self_modulate.a <= 0.0:
			nascer = false
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_pressed("zoom_m"):
		$Pivo.spring_length -= 1
	
	if Input.is_action_pressed("zoom_d"):
		$Pivo.spring_length += 1
	
	if Input.is_action_pressed("zoom_n"):
		$Pivo.spring_length = 6.0
	
	if Input.is_action_just_pressed("M1"):
		if $Area3D/Atk.is_stopped():
			$Area3D/Atk.start()
			$Area3D/MeshInstance3D.show()
			$Area3D/sumir.start()
			inimigos = inimigos.filter(func(i): return is_instance_valid(i))
			for i: Node3D in inimigos:
				if not i.is_in_group("Player"):
					if i.has_method("LevarDano"):
						i.LevarDano(1, global_position)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("Correr"):
		SPEED = 8.0
	else:
		SPEED = 5.0
	
	if knockback != Vector3.ZERO:
		knockback = knockback.move_toward(Vector3.ZERO, atrito * delta)
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	velocity.x += knockback.x
	velocity.z += knockback.z
	velocity.y += knockback.y
	knockback.y = 0.0
	
	move_and_slide()

func LevarDano(dano: float = 0.0, pi: Vector3 = Vector3.ZERO):
	if $Invencivel.is_stopped():
		Vida -= dano
		var dir = global_position.direction_to(pi) * -1
		var h = Vector3(dir.x, 0, dir.z)
		knockback = h * forcaK + Vector3.UP * 2.0
		print(dano)
		$Invencivel.start()
		$Piscar.start()
		if Vida <= 0:
			print("Morto")

func _on_invencivel_timeout() -> void:
	$Piscar.stop()
	$Invencivel.stop()
	$MeshInstance3D.transparency = 0.0

func _on_piscar_timeout() -> void:
	if $MeshInstance3D.transparency == 0.0:
		$MeshInstance3D.transparency = 0.6
	else:
		$MeshInstance3D.transparency = 0.0

func _on_atk_timeout() -> void:
	$Area3D/Atk.stop()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("LevarDano"):
		inimigos.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.has_method("LevarDano"):
		if body in inimigos:
			inimigos.erase(body)

func _on_sumir_timeout() -> void:
	$Area3D/sumir.stop()
	$Area3D/MeshInstance3D.hide()
