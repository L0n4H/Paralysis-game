extends Node

# Nœuds audio et timer gérés par le script
var heartbeat_player: AudioStreamPlayer
var heartbeat_timer: Timer

# Chemin vers l'asset audio du battement de cœur
@export var heartbeat_sound: AudioStream = preload("res://assets/audio/sfx/heartbeat.wav")

func _ready() -> void:
	_setup_nodes()
	
	# Initialiser l'intervalle avec le BPM de départ
	var initial_bpm := StressManager.get_current_bpm()
	_update_heartbeat_interval(initial_bpm)
	
	# Écouter les variations de BPM émises par le StressManager
	StressManager.bpm_changed.connect(_on_bpm_changed)
	
	# Démarrer la boucle du pouls
	heartbeat_timer.start()

func _setup_nodes() -> void:
	# 1. Création du lecteur audio
	heartbeat_player = AudioStreamPlayer.new()
	heartbeat_player.name = "HeartbeatPlayer"
	heartbeat_player.stream = heartbeat_sound
	add_child(heartbeat_player)

	# 2. Création du cadenceur (Timer)
	heartbeat_timer = Timer.new()
	heartbeat_timer.name = "HeartbeatTimer"
	heartbeat_timer.one_shot = false
	heartbeat_timer.timeout.connect(_on_heartbeat_timeout)
	add_child(heartbeat_timer)

func _on_bpm_changed(new_bpm: float) -> void:
	_update_heartbeat_interval(new_bpm)

func _update_heartbeat_interval(bpm: float) -> void:
	if bpm <= 0.0:
		return
	# Calcul du délai en secondes entre deux battements (60.0 / BPM)
	var interval := 60.0 / bpm
	heartbeat_timer.wait_time = interval

func _on_heartbeat_timeout() -> void:
	# Jouer l'échantillon à chaque pulsation
	if heartbeat_player and heartbeat_player.stream:
		heartbeat_player.play()
