class_name GLOBAL

signal updated

static var emitter: GLOBAL = GLOBAL.new()

static var flags: Dictionary = {
	&"has_destroy": false,
	&"jeff_yap": false,
	&"has_key": false,
	&"vault_opened": false,
	&"jeff_killed_by_key": false,
}

static func update_flag(flag: StringName, value):
	flags[flag] = value
	emitter.updated.emit()
