extends Node

@export var os_definition: OSSystemDefinition = preload("res://os/data/os/melon_os_definiton.tres")

@onready var os_window_container: OsWindowsContainer = $OsWindowContainer
@onready var os_task_bar: OsTaskBar = $OsTaskBar

var app_manager: OsAppManager = OsAppManager.new()


func _ready() -> void:
	for app_definition in os_definition.apps:
		app_manager.register_app(app_definition)
		
	app_manager.windows_container = os_window_container
	app_manager.task_bar = os_task_bar
	app_manager.launch_app(os_definition.apps[0].id)
	app_manager.launch_app(os_definition.apps[0].id)
