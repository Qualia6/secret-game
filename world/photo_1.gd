extends Clickable

signal secret

var last_click_time = Time.get_ticks_msec()
var short_click_count: int = 0

func _clicked(): 
	var time_past = Time.get_ticks_msec() - last_click_time
	if time_past < 30: return
	if time_past < 700 and short_click_count != 5 or short_click_count == 5 and time_past > 1500 and time_past < 4500:
		short_click_count += 1
	else:
		short_click_count = 0
	
	print(short_click_count)
	print(time_past)
	
	if short_click_count == 10:
		secret.emit()
	
	last_click_time = Time.get_ticks_msec()
