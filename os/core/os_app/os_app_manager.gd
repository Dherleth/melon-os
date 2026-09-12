class_name OsAppManager
extends Node

var available_apps: Dictionary[StringName, OsAppDefinition] = {}
var running_apps: Array[OsAppScene] = []
var windows_container: OsWindowsContainer
var task_bar: OsTaskBar



func register_app(definition: OsAppDefinition) -> void:
	available_apps[definition.id] = definition
	
	
func launch_app(app_id: StringName) -> OsAppScene:
	if not available_apps.has(app_id):
		return null

	var definition: OsAppDefinition = available_apps[app_id]

	if not definition.allow_multiple_instances:
		var existing := _get_running_instance(app_id)

		if existing:
			if windows_container:
				windows_container.focus_window(existing.os_window)
			return existing
			
	var app_instance = definition.scene.instantiate() as OsAppScene
	app_instance.app_definition = definition
	
	running_apps.append(app_instance)
	
	if windows_container:
		windows_container.open_window(app_instance)
		
	if task_bar:
		task_bar.add_app_button(app_instance)

	return app_instance
	

func close_app(app_instance: OsAppScene) -> void:
	running_apps.erase(app_instance)
	

func _get_running_instance(app_id: StringName) -> OsAppScene:
	for app in running_apps:
		if app.app_definition.id == app_id:
			return app

	return null
