class_name INVENTORY extends ColorRect

static var selected_item_id: StringName = &"none"
static var the_only_inventory: INVENTORY = null

var selected_item_object: CanvasItem = null

func _ready():
	GLOBAL.emitter.updated.connect(_updated)
	$Key.visible = false
	$Empty.visible = true
	visible = false
	the_only_inventory = self


func _updated():
	var items: int = 0
	
	$Key.visible = GLOBAL.flags[&"has_key"]
	items += int(GLOBAL.flags[&"has_key"])
	if not GLOBAL.flags[&"has_key"] and selected_item_id == &"key": deselect_current_item()
	
	$Gun.visible = GLOBAL.flags[&"has_gun"]
	items += int(GLOBAL.flags[&"has_gun"])
	if not GLOBAL.flags[&"has_gun"] and selected_item_id == &"gun": deselect_current_item()
	if $Gun.visible: %"gun asset".play_animation(GLOBAL.flags[&"gun_lvl"])
	
	var money: int = GLOBAL.flags[&"money"]
	$Money.visible = money >= 1
	%second_money.visible = money >= 2
	items += money
	if money == 0 and selected_item_id == &"money": deselect_current_item()
	
	$Empty.visible = items == 0

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		visible = not visible
		if not visible:
			$animation.pause()
		else:
			$animation.play()



func _on_item_clicked(item: CanvasItem, id: StringName) -> void:
	if selected_item_id == id: 
		deselect_current_item()
		return
	deselect_current_item()
	#print(selected_item_object)
	selected_item_object = item
	selected_item_id = id
	selected_item_object.get_parent().scale = Vector2(0.25,0.25)


static func deselect_current_item():
	if the_only_inventory.selected_item_object != null:
		the_only_inventory.selected_item_object.get_parent().rotation = 0
		the_only_inventory.selected_item_object.get_parent().scale = Vector2(0.5,0.5)
	the_only_inventory.selected_item_object = null
	selected_item_id = &"none"


func _gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton: return
	if not event.button_index == MOUSE_BUTTON_LEFT: return
	if not event.pressed: return
	deselect_current_item()

func _process(delta: float):
	if selected_item_object != null:
		selected_item_object.get_parent().rotation += delta * 20
