extends Node2D

func _ready() -> void:
	$anim.play("RESET")

func play_animation(animation: int) -> void:
	print("Now playing animation", animation)
	$anim.stop()
	match animation:
		1: $anim.play("1")
		2: $anim.play("2")
		_: $anim.play("RESET")
