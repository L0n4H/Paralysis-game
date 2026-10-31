extends CharacterBody2D

@export_group("Déplacements")
@export var speed: float = 220.0
@export var acceleration: float = 1400.0
@export var friction: float = 2000.0

@export_group("Saut & Physique")
@export var jump_velocity: float = -300.0
@export var coyote_time: float = 0.15
@export var jump_buffer_time: float = 0.12

@export var fall_gravity_multiplier: float = 1.8

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

func _physics_process(delta: float) -> void:
	# 1. Appliquer la gravité et le Coyote Time
	if not is_on_floor():
		# Calcul de la gravité effective pour cette frame
		var applied_gravity: float = gravity
		if velocity.y > 0: # Le joueur est en train de tomber
			applied_gravity *= fall_gravity_multiplier
		velocity.y += applied_gravity * delta
		coyote_timer -= delta
	else:
		coyote_timer = coyote_time

	# 2. Décrémenter le buffer de saut
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	# 3. Enregistrer l'intention de saut
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up"):
		jump_buffer_timer = jump_buffer_time

	# 4. Exécuter le saut si les conditions sont remplies
	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		velocity.y = jump_velocity
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	# 5. Gestion des déplacements horizontaux avec inertie
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)

	move_and_slide()
