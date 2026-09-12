class_name OSDesktop
extends Control

var os: OSSystem

@export var app_icon_scene: PackedScene
@onready var app_container: Control = $AppContainer


func setup(os_system: OSSystem) -> void:
	os = os_system

	for definition in os.definition.apps:
		create_app_icon(definition)


func create_app_icon(definition: OsAppDefinition) -> void:
	var icon := app_icon_scene.instantiate() as OsAppIcon
	app_container.add_child(icon)
	icon.setup(definition)
	icon.app_requested.connect(_on_app_requested)


func _on_app_requested(definition: OsAppDefinition) -> void:
	os.launch_app(definition.id)
