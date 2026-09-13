class_name OsWindowsContainer
extends Control

var window_scene: PackedScene = preload("res://os/core/os_window/os_window.tscn")


func open_window(app_instance: OsAppScene) -> OsWindow:
	var window := window_scene.instantiate() as OsWindow
	
	add_child(window)
	window.setup(app_instance)
	
	var screen_size = window.get_viewport_rect().size
	window.position = Vector2(screen_size.x / 2 - window.size.x / 2, screen_size.y * 0.1)
	
	window.focused.connect(focus_window)

	return window
	
	
func focus_window(window: OsWindow) -> void:
	move_child(window, get_child_count() - 1)
