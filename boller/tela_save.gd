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

func _on_static_body_2d_mouse_entered() -> void:
	pass # Replace with function body.

func _on_static_body_2d_mouse_exited() -> void:
	pass # Replace with function body.
