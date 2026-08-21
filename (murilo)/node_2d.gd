extends Node2D

var nascer: bool = true
var escurecer: bool = false

func _physics_process(delta: float) -> void:
	if nascer:
		$MeshInstance2D.self_modulate.a -= delta
		if $MeshInstance2D.self_modulate.a <= 0.0:
			nascer = false
	if escurecer:
		$MeshInstance2D.self_modulate.a += delta
		if $MeshInstance2D.self_modulate.a >= 1.0:
			get_tree().change_scene_to_file("res://node_3d.tscn")

func _on_static_body_2d_mouse_entered() -> void:
	$StaticBody2D/Label.text = "< Play >"

func _on_static_body_2d_mouse_exited() -> void:
	$StaticBody2D/Label.text = "Play"

func _on_static_body_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("M1"):
		if not nascer:
			$AudioStreamPlayer2.play()
			escurecer = true
