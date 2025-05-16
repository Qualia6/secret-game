class_name GLOBAL

signal updated

static var emitter: GLOBAL = GLOBAL.new()

const starting_flags = {
	&"has_gun": false,
	&"jeff_yap": false,
	&"has_key": false,
	&"vault_opened": false,
	&"jeff_killed_by_key": false,
	&"jeff_dead": false,
	&"june_dead": false,
	&"jerboa_dead": false,
	&"money": 0,
	&"gun_lvl": -1,
	&"jerboa_showed_gun": false,
	&"control_pannel_destroied": false,
	&"recovery_center_destroied": false,
	&"ceiling_broken": false,
	&"jeff_jumped_before": false,
	&"spoken_to_m": false,
	&"jerboa_talking_about_money": false,
	&"june_moved": false,
	&"jeff_mentioned_hole": false,
	&"jerboa_up": false,
	&"jeff_up": false,
	&"june_up": false,
	&"game_end": false,
	&"jeff_said_puzzle": false,
}

static var flags: Dictionary = starting_flags.duplicate()

static func update_flag(flag: StringName, value):
	flags[flag] = value
	emitter.updated.emit()

static func reset():
	flags = starting_flags.duplicate()
