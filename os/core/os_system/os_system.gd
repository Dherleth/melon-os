class_name OsSystem
extends Node

@export var os_definition: OSSystemDefinition = preload("res://os/data/os/melon_os_definiton.tres")

@onready var os_window_container: OsWindowsContainer = $OsWindowContainer
@onready var os_task_bar: OsTaskBar = $OsTaskBar
@onready var os_notification_center: OsNotificationCenter = $OsNotificationCenter

const FILE_ASSOCIATIONS := {
	"png": "imager",
	"jpg": "imager",
	"jpeg": "imager",
	"webp": "imager",
	"gif": "imager",

	"txt": "texter",
	"md": "texter",

	"mp3": "sounder",
	"wav": "sounder",
	"ogg": "sounder",
}

var app_manager: OsAppManager = OsAppManager.new()

func _ready() -> void:
	app_manager.os_system = self
	app_manager.windows_container = os_window_container
	app_manager.task_bar = os_task_bar
	
	for app_definition in os_definition.apps:
		app_manager.register_app(app_definition)
		
	
	app_manager.launch_app("file_explorer")
	
	

func open_file(file_path: String):
	var file_extension = file_path.get_extension()
	
	if FILE_ASSOCIATIONS.has(file_extension):
		var app_id = FILE_ASSOCIATIONS[file_extension]
		app_manager.launch_app(app_id, file_path)
	else:
		add_notification("No app able to open that file")
		
		
func add_notification(text: String) -> void:
	os_notification_center.add_notification(text)
