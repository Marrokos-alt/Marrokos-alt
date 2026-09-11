extends Node2D

var escurecer: bool = false
var tocado: bool = false
var nascer: bool = true

func _ready() -> void:
	nascer = true
	$AudioStreamPlayer.play(Global.Musica)

func _process(delta: float) -> void:
	if nascer:
		$MeshInstance2D2.self_modulate.a -= delta
		if $MeshInstance2D2.self_modulate.a <= 0.0:
			nascer = false
			print("nasci")
	if escurecer:
		print("preto")
		$MeshInstance2D2.self_modulate.a += delta
		if $MeshInstance2D2.self_modulate.a >= 1.0:
			get_tree().change_scene_to_file("res://tela_save.tscn")

func _on_static_body_2d_mouse_entered() -> void:
	$Start1.hide()
	$Start2.show()

func _on_static_body_2d_mouse_exited() -> void:
	$Start2.hide()
	$Start1.show()

func _on_static_body_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("M1"):
		print("M1")
		if not tocado:
			print("escuro")
			escurecer = true
			tocado = true
