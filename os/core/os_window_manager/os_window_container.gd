class_name OsWindowsContainer
extends Control

var window_scene: PackedScene = preload("res://os/core/os_window/os_window.tscn")


func _ready() -> void:
	OsSystem.app_manager.windows_container = self


func open_window(app_instance: OsAppScene) -> OsWindow:
	var window := window_scene.instantiate() as OsWindow
	
	add_child(window)
	window.setup(app_instance)
	window.focused.connect(focus_window)
	window.closed.connect(_on_window_closed)

	return window
	
func focus_window(window: OsWindow) -> void:
	move_child(window, get_child_count() - 1)
	
	
func _on_window_closed(os_window: OsWindow) -> void:
	OsSystem.app_manager.close_app(os_window.app_instance)
	os_window.queue_free()
	
