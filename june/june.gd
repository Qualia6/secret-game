extends NPC

var not_realized_jeff_key_killed: bool = true

func _updated():
	if not_realized_jeff_key_killed and GLOBAL.flags[&"jeff_killed_by_key"]:
		goto("WOW KEY KILL")
		not_realized_jeff_key_killed = false
