class_name OsWindowManager
extends Control

var windows: Array[OsWindow] = []
var window_scene: PackedScene = preload("res://os/core/os_window/os_window.tscn")

	
func open_window(definition: OsAppDefinition) -> OsWindow:
	var window := window_scene.instantiate() as OsWindow
	add_child(window)
	windows.append(window)
	window.closed.connect(close_window)
	focus_window(window)

	return window


func close_window(window: OsWindow) -> void:
	if not windows.has(window):
		return

	windows.erase(window)
	window.queue_free()


func focus_window(window: OsWindow) -> void:
	if not windows.has(window):
		return

	move_child(window, get_child_count() - 1)
