extends CanvasLayer

@onready var stress_bar: ProgressBar = $StressBar
@onready var bpm_label: Label = $BPMLabel

func _ready() -> void:
	# 1. Initialiser la barre et le texte avec les valeurs actuelles
	stress_bar.value = StressManager.stress
	_update_bpm(StressManager.get_current_bpm())
	
	# 2. Connecter les signaux du StressManager
	StressManager.stress_changed.connect(_on_stress_changed)
	StressManager.bpm_changed.connect(_on_bpm_changed)

func _on_stress_changed(new_value: float) -> void:
	stress_bar.value = new_value

func _on_bpm_changed(new_bpm: float) -> void:
	_update_bpm(new_bpm)

func _update_bpm(bpm: float) -> void:
	bpm_label.text = "BPM : %d" % roundi(bpm)
