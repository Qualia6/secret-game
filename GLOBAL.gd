class_name GLOBAL

signal updated

static var emitter: GLOBAL = GLOBAL.new()

static var flags: Dictionary = {
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
}

static func update_flag(flag: StringName, value):
	flags[flag] = value
	emitter.updated.emit()
