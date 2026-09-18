class_name OsSystem
extends Node

@export var os_definition: OsSystemDefinition = preload("res://os/data/os/melon_os_definiton.tres")

@onready var os_window_container: OsWindowsContainer = $OsWindowContainer
@onready var os_task_bar: OsTaskBar = $OsTaskBar
@onready var os_notification_center: OsNotificationCenter = $OsNotificationCenter

var app_manager: OsAppManager = OsAppManager.new()

func _ready() -> void:
	app_manager.os_system = self
	app_manager.windows_container = os_window_container
	app_manager.task_bar = os_task_bar
	
	for app_definition in os_definition.apps:
		app_manager.register_app(app_definition)
		
		
	open_file(os_definition.filesystem_base_path)
	
	
# Determines the app to use to open the file with FILE_ASSOCIATIONS.
# The app then has the responsability to know how to open the file and use the
# data in it.
func open_file(file_path: String):
	var file_extension = file_path.get_extension()
	
	if os_definition.file_associations.has(file_extension):
		var app_id = os_definition.file_associations[file_extension].id
		app_manager.launch_app(app_id, file_path)
	else:
		add_notification("No app able to open that file")
		
		
func add_notification(text: String) -> void:
	os_notification_center.add_notification(text)
	

func get_file_app_association(file_path: String) -> OsAppDefinition:
	var file_extension = file_path.get_extension()
	
	if os_definition.file_associations.has(file_extension):
		var definition := os_definition.file_associations[file_extension]
		
		return definition
	
	return null
