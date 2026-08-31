class_name OsAppDefinition
extends Resource

@export var id: StringName
@export var name: String
@export var icon: Texture2D
@export var scene: PackedScene

@export_group("Window")
@export var default_size := Vector2(800, 500)

@export_group("Instances")
@export var allow_multiple_instances := false
