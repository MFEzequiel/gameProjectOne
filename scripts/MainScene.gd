extends Node

onready var en = get_node("/root/MainScene/BasicSnail")


func _ready() -> void:
	randomize()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("R"):
		get_tree().reload_current_scene()
