class_name OSDefinition
extends Resource

@export var os_name: String = "My OS"

@export_group("Appearance")
@export var wallpaper: Texture2D

@export_group("App")
@export var apps: Array[OsAppDefinition]

@export_group("Filesystem")
@export var filesystem: OSFileSystemDefinition
