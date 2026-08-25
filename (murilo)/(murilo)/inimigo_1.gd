extends CharacterBody3D

var player: CharacterBody3D
var can: bool
var stun: bool = false
var knockback: Vector3
var Vida: float = 25

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity = get_gravity() * delta
	
	if knockback != Vector3.ZERO:
		knockback = knockback.move_toward(Vector3.ZERO, 20.0 * delta)
	
	if can:
		if player != null:
			if not stun:
				$NavigationAgent3D.target_position = player.global_position
				var pp = $NavigationAgent3D.get_next_path_position()
				var dir = global_position.direction_to(pp)
				velocity.x = 5.0 * dir.x
				velocity.z = 5.0 * dir.z
	
	velocity += knockback
	knockback.y = 0.0
	
	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("LevarDano"):
		if body.is_in_group("Player"):
			body.LevarDano(5, global_position)
			stun = true
			$Timer.start()

func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if body is CharacterBody3D:
			player = body
			can = true

func _on_area_3d_2_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if body is CharacterBody3D:
			player = null
			can = false

func _on_timer_timeout() -> void:
	$Timer.stop()
	stun = false

func LevarDano(dano: float = 0.0, pi: Vector3 = Vector3.ZERO):
	var dir = global_position.direction_to(pi) * -1
	var h = Vector3(dir.x, 0, dir.z)
	knockback = h * 5.0 + Vector3.UP * 2.0
	Vida -= dano
	if Vida <= 0:
		queue_free()
