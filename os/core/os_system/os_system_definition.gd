class_name OsSystemDefinition
extends Resource

@export_group("Filesystem")
@export_dir var filesystem_base_path := "res://os/sample_data/filesystem"
@export var extensions_to_hide: Array[String] = []
@export var file_associations: Dictionary[String, OsAppDefinition] = {}

@export_group("Desktop")
@export var desktop_icons_per_column := 8
@export var background: Texture2D
