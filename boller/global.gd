extends Node

var Musica: float = 0.0

func _process(delta: float) -> void:
	musica(delta)

func musica(delta: float):
	Musica += delta
	if Musica >= 149.0:
		Musica = 0.0
