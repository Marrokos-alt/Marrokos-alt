extends Node2D

var can: bool = true
var id: int = 0

func _process(delta: float) -> void:
	if can:
		if Input.is_action_just_pressed("ui_up"):
			if id == 0:
				get_tree().call_group("Player", "Dialogo", "A benção vinda das raças superiores nos\npermitira evoluir a nossa alma a um patamar superior\n-Apex")
				id += 1
			elif id == 1:
				get_tree().call_group("Player", "Dialogo", "")
				id = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$TileMapLayer3.hide()
		can = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$TileMapLayer3.show()
		can = false
