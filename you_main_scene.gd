extends Control

@export var os_scene: PackedScene

func _on_button_pressed() -> void:
	if os_scene:
		var os_instance := os_scene.instantiate() as OsSystem
		add_child(os_instance)
