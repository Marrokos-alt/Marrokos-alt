extends SpringArm3D

@export var sensibilidade: float = 0.005

func _ready() -> void:
	self.top_level = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * sensibilidade
		rotation.y = wrapf(rotation.y, 0.0, TAU)
		rotation.x -= event.relative.y * sensibilidade
		rotation.x = clamp(rotation.x, -PI/2, PI/4)
