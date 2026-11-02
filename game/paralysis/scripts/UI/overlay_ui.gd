extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	_update_vignette(StressManager.stress)
	StressManager.stress_changed.connect(_on_stress_changed)

func _on_stress_changed(new_value: float) -> void:
	_update_vignette(new_value)

func _update_vignette(stress_value: float) -> void:
	if color_rect and color_rect.material is ShaderMaterial:
		(color_rect.material as ShaderMaterial).set_shader_parameter("stress", stress_value)
