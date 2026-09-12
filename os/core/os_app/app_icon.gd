class_name OsAppIcon
extends Button

signal app_requested(app: OsAppDefinition)

var definition: OsAppDefinition


func setup(
	app_definition: OsAppDefinition
) -> void:
	definition = app_definition

	text = definition.app_name

	if definition.icon:
		icon = definition.icon

	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	app_requested.emit(definition)
