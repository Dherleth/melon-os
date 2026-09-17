class_name OsAppManager
extends Node

var available_apps: Dictionary[StringName, OsAppDefinition] = {}
var running_apps: Array[OsAppScene] = []

var windows_container: OsWindowsContainer
var task_bar: OsTaskBar
var os_system: OsSystem


func register_app(definition: OsAppDefinition) -> void:
	available_apps[definition.id] = definition
	
	
func launch_app(app_id: StringName, file_path := "") -> OsAppScene:
	# Does the app with app_id exists ?
	if not available_apps.has(app_id):
		os_system.add_notification("No app able to open that file")
		return null

	var definition: OsAppDefinition = available_apps[app_id]
	
	# Can the app be launched multiple times ?
	if not definition.allow_multiple_instances:
		var existing := _get_running_instance(app_id)

		if existing:
			if windows_container:
				windows_container.focus_window(existing.os_window)
			return existing
	
	# Instantiate the app and sets it's necessary data to work
	var app_instance = definition.scene.instantiate() as OsAppScene
	app_instance.app_definition = definition
	app_instance.file_path = file_path
	app_instance.os_system = os_system
	
	running_apps.append(app_instance)
	
	# Opens a window and gives it the app.
	if windows_container:
		var app_window := windows_container.open_window(app_instance)
		app_window.closed.connect(_on_app_window_closed)
		app_window.focused.connect(_on_app_window_focused)
		app_instance.setup()
	
	# Add a task bar button for that app instance
	if task_bar:
		task_bar.add_app_button(app_instance)

	return app_instance
	
# 
func close_app(app_instance: OsAppScene) -> void:
	app_instance.queue_free()
	running_apps.erase(app_instance)
	

func _on_app_window_closed(app_window: OsWindow) -> void:
	close_app(app_window.app_instance)
	

func _on_app_window_focused(app_window: OsWindow) -> void:
	windows_container.focus_window(app_window)
	task_bar.set_app_buttons_focus(app_window)
	

func _get_running_instance(app_id: StringName) -> OsAppScene:
	for app in running_apps:
		if app.app_definition.id == app_id:
			return app

	return null
