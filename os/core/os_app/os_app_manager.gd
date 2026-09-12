class_name AppManager
extends Container

var window_scene: PackedScene = preload("res://os/core/os_window/os_window.tscn")
var available_apps: Dictionary[StringName, OsAppDefinition] = {}
var running_apps: Array[OsApp] = []


func register_app(definition: OsAppDefinition) -> void:
	available_apps[definition.id] = definition
	
	
func launch_app(app_id: StringName) -> OsApp:
	if not available_apps.has(app_id):
		return null

	var definition: OsAppDefinition = available_apps[app_id]

	if not definition.allow_multiple_instances:
		var existing := _get_running_instance(app_id)

		if existing:
			_focus_window(existing.window)
			return existing

	var window := _open_window(definition)
	
	var app := window.app
	app.window = window
	running_apps.append(app)

	return app


func _get_running_instance(app_id: StringName) -> OsApp:
	for app in running_apps:
		if app.definition.id == app_id:
			return app

	return null

	
func _open_window(app_definition: OsAppDefinition) -> OsWindow:
	var window := window_scene.instantiate() as OsWindow
	add_child(window)
	window.setup(app_definition)
	window.closed.connect(_on_window_closed)
	_focus_window(window)

	return window


func _focus_window(window: OsWindow) -> void:
	move_child(window, get_child_count() - 1)
	

func _on_window_closed(window: OsWindow) -> void:
	running_apps.erase(window.app)
	window.queue_free()
