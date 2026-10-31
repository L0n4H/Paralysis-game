extends Node

signal stress_changed(new_value: float)
signal bpm_changed(new_bpm: float)

@export var stress_increase_rate: float = 15.0
@export var stress_decrease_rate: float = 10.0
	
@export var min_bpm: float = 60.0
@export var max_bpm: float = 170.0

var is_in_darkness: bool = false

var stress: float = 0.0:
	set(value):
		var old_stress := stress
		stress = clampf(value, 0.0, 100.0)
		if stress != old_stress:
			stress_changed.emit(stress)
			bpm_changed.emit(get_current_bpm())

func _process(delta: float) -> void:
	# 1. Mise à jour temporaire de l'état d'obscurité via la touche T
	is_in_darkness = Input.is_key_pressed(KEY_T)
	
	# 2. Évolution du stress
	if is_in_darkness:
		stress += stress_increase_rate * delta
	else:
		stress -= stress_decrease_rate * delta

func get_current_bpm() -> float:
	return lerpf(min_bpm, max_bpm, stress / 100.0)
