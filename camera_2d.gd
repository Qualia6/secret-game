extends Camera2D

@export var SPEED: float
@export var ACCEL_RATE: float
var acceleration: float = 0

@export var min_x: float
@export var max_x: float

enum CAMERA_STATE {CONTROLLED, MOVE, FREEZE}
var state: CAMERA_STATE = CAMERA_STATE.CONTROLLED
var before_animation_position: Vector2
var animation_t: float = 0.

func _process(delta: float) -> void:
	match state:
		CAMERA_STATE.CONTROLLED:
			var desired_dir: float = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
			var no_keys_presssed_multiplier = 2. if (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")) else 4.
			var jerk: float = max(abs(desired_dir - acceleration) * no_keys_presssed_multiplier, 1) * ACCEL_RATE
			if desired_dir > acceleration:
				acceleration = min(acceleration + delta * jerk, desired_dir)
			else:
				acceleration = max(acceleration - delta * jerk, desired_dir)
			position.x += acceleration * SPEED
			position.x = clamp(position.x, min_x, max_x)
		CAMERA_STATE.MOVE:
			animation_t += delta / 2.5
			if animation_t >= 1.:
				animation_t = 1.
				state = CAMERA_STATE.FREEZE
			position = lerp(before_animation_position, Vector2(1226, -647.0), animation_t)
			zoom = Vector2(1. - animation_t * 0.4, 1. - animation_t * 0.4)

func _ready():
	position = Vector2(600, 320)
	$blinders.visible = true
	zoom = Vector2(1., 1.)

func _on_vault_travel_through_vault() -> void:
	position.y = 1000

func _on_arrow_out_of_vault_clicked() -> void:
	position.y = 320

func _on_arrow_into_hole_clicked() -> void:
	position.y = 1000

func _on_ceilling_hole_utilize_hole() -> void:
	position.y = -455

func _on_row_0_arrow_back_down() -> void:
	position.y = 320

func _on_row_0_fix_camera_position() -> void:
	$blinders.visible = false
	before_animation_position = position
	state = CAMERA_STATE.MOVE
	animation_t = 0.
