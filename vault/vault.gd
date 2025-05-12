extends Clickable

var opened : bool = false

signal travel_through_vault


func _clicked() -> void:
	if INVENTORY.selected_item_id != &"key": return
	if opened: return
	opened = true
	$animation.play("open")


func _on_animation_animation_finished(anim_name: StringName) -> void:
	GLOBAL.update_flag(&"vault_open", true)


func _on_into_vault_arrow_clicked() -> void:
	travel_through_vault.emit()
