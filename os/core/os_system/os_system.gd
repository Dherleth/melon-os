extends Node

var os_definition: OSSystemDefinition = preload("res://os/data/os/melon_os_definiton.tres")

var app_manager: OsAppManager = OsAppManager.new()

func _ready() -> void:
	for app_definition in os_definition.apps:
		app_manager.register_app(app_definition)
