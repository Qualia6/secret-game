extends NPC

func _get_executions() -> Dictionary[String, Callable]:
	return {
		"appear": appear,
		"leave": leave,
		"appear_angry": appear_angry,
		"leave_angry": leave_angry,
		"game_over": game_over
	}

func appear() -> Signal:
	$sound.play()
	visible = true
	say("")
	animation_t = 0.
	animation_state = ANIMATION_STATE.APPEAR
	return done_moving

func leave() -> Signal:
	$sound.play()
	visible = true
	say("")
	animation_t = 0.
	animation_state = ANIMATION_STATE.LEAVE
	return done_moving

func appear_angry() -> Signal:
	$sound.play()
	visible = true
	say("")
	animation_t = 0.
	animation_state = ANIMATION_STATE.APPEAR_ANGRY
	return done_moving

func leave_angry() -> Signal:
	$sound.play()
	visible = true
	say("")
	animation_t = 0.
	animation_state = ANIMATION_STATE.LEAVE_ANGRY
	return done_moving

signal game_is_over

func game_over():
	game_is_over.emit()
	get_tree().change_scene_to_file("res://game_over.tscn")

signal done_moving

enum ANIMATION_STATE {NONE, APPEAR, APPEAR_ANGRY, LEAVE, LEAVE_ANGRY}
var animation_state: ANIMATION_STATE = ANIMATION_STATE.NONE
var animation_t: float = 1.


func get_vertical_t() -> float:
	return 1. - animation_t if animation_state == ANIMATION_STATE.APPEAR or animation_state == ANIMATION_STATE.APPEAR_ANGRY else animation_t


func _process(delta: float) -> void:
	if animation_state == ANIMATION_STATE.NONE: return
	animation_t += delta * 0.35
	if animation_t >= 1.:
		animation_t = 1.
		done_moving.emit()
		if animation_state == ANIMATION_STATE.LEAVE or animation_state == ANIMATION_STATE.LEAVE_ANGRY:
			visible = false
	var verticality_t = get_vertical_t()
	$sound.volume_db = verticality_t * -20 + 10
	position = Vector2(-195, -85 + verticality_t * 500)
	if animation_state == ANIMATION_STATE.APPEAR_ANGRY or animation_state == ANIMATION_STATE.LEAVE_ANGRY:
		if animation_t != 1.:
			position += Vector2(randf()-0.5,randf()-0.5)*80.
	if animation_t >= 1.:
		animation_state = ANIMATION_STATE.NONE

var arrive: int = 0
var imma_kill_you_now: bool = false

func summoned():
	if visible: return
	if GLOBAL.flags[&"game_end"]: return
	if animation_state != ANIMATION_STATE.NONE: return
	if imma_kill_you_now: return
	arrive += 1
	match arrive:
		1: goto("ARRIVE FIRST")
		2: goto("ARRIVE SECOND")
		3: goto("ARRIVE THIRD")
		_: goto("ARRIVE FOURTH")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cave money"):
		summoned()

func _on_photo_1_secret() -> void:
	summoned()


func _updated():
	if GLOBAL.flags[&"jeff_dead"] and GLOBAL.flags[&"june_dead"] and GLOBAL.flags[&"jerboa_dead"] and \
			GLOBAL.flags[&"control_pannel_destroied"] and GLOBAL.flags[&"recovery_center_destroied"] and not imma_kill_you_now:
		imma_kill_you_now = true
		match animation_state:
			ANIMATION_STATE.NONE:
				if visible:
					goto("GENOCIDE ALREADY HERE")
				else:
					goto("GENOCIDE")
			ANIMATION_STATE.APPEAR:
				await done_moving
				goto("GENOCIDE ALREADY HERE")
			ANIMATION_STATE.APPEAR_ANGRY:
				animation_state = ANIMATION_STATE.APPEAR
				await done_moving
				goto("GENOCIDE ALREADY HERE")
			ANIMATION_STATE.LEAVE:
				await done_moving
				goto("GENOCIDE")
			ANIMATION_STATE.LEAVE_ANGRY:
				await done_moving
				goto("GENOCIDE")
