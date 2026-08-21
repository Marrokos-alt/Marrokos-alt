extends CharacterBody3D

@export var SPEED = 5.0
const JUMP_VELOCITY = 4.5
var nascer:  bool = true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Timer.start()

func _process(delta: float) -> void:
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

func _physics_process(delta: float) -> void:
	var d = abs(wrapf(rotation.y - $Pivo.rotation.y, -PI, PI))
	if d <= 1.0:
		rotation.y = lerp(rotation.y, $Pivo.rotation.y, 0.1)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("Correr"):
		SPEED = 7.0
	else:
		SPEED = 5.0
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
