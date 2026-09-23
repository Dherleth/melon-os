class_name OsSystem
extends Control

signal turned_off(os_system: OsSystem)

@export var os_definition: OsSystemDefinition = preload("res://os/sample_data/sample_os_definiton.tres")

@onready var background: TextureRect = $Background
@onready var os_window_container: OsWindowsContainer = $OsWindowContainer
@onready var os_task_bar: OsTaskBar = $OsTaskBar
@onready var os_notification_center: OsNotificationCenter = $OsNotificationCenter
@onready var os_desktop: OsDesktop = $OsDesktop

var app_manager: OsAppManager = OsAppManager.new()

func _ready() -> void:
	hide()
	background.texture = os_definition.background
	app_manager.os_system = self
	app_manager.windows_container = os_window_container
	app_manager.task_bar = os_task_bar
	
	os_task_bar.os_system = self
	
	os_desktop.os_system = self
	os_desktop.setup()
	
	
# Determines the app to use to open a file.
# The app then has the responsability to know how to open the file and use the
# data in it.
func open_file(file_path: String):
	var app_definition = get_file_app_association(file_path)
	
	if app_definition:
		app_manager.launch_app(app_definition, file_path)
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


func turn_on() -> void:
	show()
	

func turn_off() -> void:
	hide()
	turned_off.emit(self)
	
# Helper to easily create a new OsSystem instance without passing the scene path around.
# You can provide your own OS definition or use the default one
static func create(os_definition_p: OsSystemDefinition = null) -> OsSystem:
	var os_instance = preload("res://os/core/os_system/os_system.tscn").instantiate() as OsSystem
	if os_definition_p:
		os_instance.os_definition = os_definition_p
	
	return os_instance
