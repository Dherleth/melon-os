class_name OsSystemDefinition
extends Resource

@export_group("Apps")
@export var apps: Array[OsAppDefinition]

@export_group("Filesystem")
@export var filesystem_base_path := "res://os/data/filesystem"
@export var extensions_to_hide: Array[String] = []
@export var file_associations: Dictionary[String, OsAppDefinition] = {}
