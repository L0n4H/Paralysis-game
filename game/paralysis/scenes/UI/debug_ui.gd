extends CanvasLayer

@onready var stress_bar: ProgressBar = $StressBar

func _ready() -> void:
	# Initialiser la barre avec la valeur actuelle au chargement
	stress_bar.value = StressManager.stress
	# Connecter le signal du Singleton
	StressManager.stress_changed.connect(_on_stress_changed)

func _on_stress_changed(new_value: float) -> void:
	stress_bar.value = new_value
