class_name OSSystem
extends Control

@export var definition: OSDefinition

@onready var window_manager: OsWindowManager = $OsWindowManager
@onready var app_manager: AppManager = $AppManager
@onready var desktop: OSDesktop = $Desktop


func _ready() -> void:
	app_manager.setup(
		self,
		window_manager
	)
	
	desktop.setup(self)
	
	for app_definition in definition.apps:
		app_manager.register_app(
			app_definition
	)


func launch_app(app_id: StringName) -> OsApp:
	return app_manager.launch(app_id)
