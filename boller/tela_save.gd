extends Node2D

var nascer: bool = false
var tocado: bool = false
var escurecer: bool = false

func _ready() -> void:
	$AudioStreamPlayer.play(Global.Musica)
	$MeshInstance2D2.show()
	nascer = true

func _process(delta: float) -> void:
	if nascer:
		$MeshInstance2D2.self_modulate.a -= delta
		if $MeshInstance2D2.self_modulate.a <= 0.0:
			nascer = false
	if escurecer:
		$MeshInstance2D2.self_modulate.a += delta
		if $MeshInstance2D2.self_modulate.a <= 1.0:
			escurecer = false
			get_tree().change_scene_to_file("res://sala_inicial.tscn")

func _on_static_body_2d_mouse_entered() -> void:
	if Input.is_action_just_pressed("M1"):
		escurecer = true
	$Back1.hide()
	$Back2.show()

func _on_static_body_2d_mouse_exited() -> void:
	$Back2.hide()
	$Back1.show()
