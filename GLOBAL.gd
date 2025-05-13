class_name GLOBAL

signal updated

static var emitter: GLOBAL = GLOBAL.new()

static var flags: Dictionary = {
	&"has_destroy": false,
	&"jeff_yap": false,
	&"has_key": false,
	&"vault_opened": false,
	&"jeff_killed_by_key": false,
	&"jeff_dead": false,
	&"june_dead": false,
	&"jerboa_dead": false,
	&"has_money": false,
}

static func update_flag(flag: StringName, value):
	#print("before: ", flags)
	flags[flag] = value
	#print(flag, " was updated to be ", value)
	#print("after: ", flags)
	#print()
	emitter.updated.emit()
