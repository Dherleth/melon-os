class_name AppManager
extends Node

signal app_started(app: OsApp)
signal app_closed(app: OsApp)

var apps: Dictionary[StringName, OsAppDefinition] = {}
var running_apps: Array[OsApp] = []

var os: OSSystem
var window_manager: OsWindowManager


func setup(
	os_system: OSSystem,
	manager: OsWindowManager
) -> void:
	os = os_system
	window_manager = manager


func register_app(
	definition: OsAppDefinition
) -> void:

	apps[definition.id] = definition


func launch(app_id: StringName) -> OsApp:
	if not apps.has(app_id):
		push_error(
			"Application not found: " + str(app_id)
		)
		return null

	var definition: OsAppDefinition = apps[
		app_id
	]

	if not definition.allow_multiple_instances:
		var existing := get_running_instance(app_id)

		if existing:
			window_manager.focus_window(existing.window)
			return existing

	var window := window_manager.open_window(definition)

	var app := window.app

	running_apps.append(app)

	app.closed.connect(
		_on_app_closed.bind(app)
	)
	
	app_started.emit(app)

	return app
	
	
func _on_app_closed(app: OsApp) -> void:
	running_apps.erase(app)
	app_closed.emit(app)
	
	
func get_running_instance(
	app_id: StringName
) -> OsApp:

	for app in running_apps:
		if app.definition.id == app_id:
			return app

	return null
