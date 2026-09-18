class_name OsWindowsContainer
extends Control

var window_scene: PackedScene = preload("res://os/core/os_window/os_window.tscn")


func open_window(app_instance: OsAppScene) -> OsWindow:
	var window := window_scene.instantiate() as OsWindow
	
	add_child(window)
	window.setup(app_instance)
	
	var screen_size = window.get_viewport_rect().size
	var pos_x = (screen_size.x / 2 - window.size.x / 2) + randi_range(-100, 100)
	var pos_y = randi_range(100, 200)
	window.position = Vector2i(pos_x, pos_y)
	
	window.focused.connect(focus_window)

	return window
	
	
func focus_window(window: OsWindow) -> void:
	move_child(window, get_child_count() - 1)
