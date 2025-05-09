extends Camera2D

@export var SPEED: float
@export var ACCEL_RATE: float
var acceleration: float = 0


func _physics_process(delta: float) -> void:
	var desired_dir: float = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var no_keys_presssed_multiplier = 2. if (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")) else 4.
	var jerk: float = max(abs(desired_dir - acceleration) * no_keys_presssed_multiplier, 1) * ACCEL_RATE
	if desired_dir > acceleration:
		acceleration = min(acceleration + delta * jerk, desired_dir)
	else:
		acceleration = max(acceleration - delta * jerk, desired_dir)
	position.x += acceleration * SPEED
