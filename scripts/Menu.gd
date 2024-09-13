extends Control

# Default game server port.
const DEFAULT_PORT = 8910

onready var conf = $Config


func _ready() -> void:
	$Particles2D.emitting = true
	conf.disabled = true


func _on_Play_pressed() -> void:
	get_tree().change_scene("res://scene/roon/MainScene.tscn")


func _on_Config_pressed() -> void:
	pass # Replace with function body.


func _on_Exit_pressed() -> void:
	get_tree().notification(NOTIFICATION_WM_QUIT_REQUEST)
