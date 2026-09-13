class_name OsAppScene
extends Control

signal focused(app_instance: OsAppScene)

var app_definition: OsAppDefinition
var os_window: OsWindow

# The file that launched the app.
# The file contains all the infos for the app and the app should know how to open it
# and read it.
# And as dev, you know in which manner to write the data in the file for a specific app
var file_path := ""

func setup() -> void:
	pass
	
	
func get_window_name() -> String:
	return file_path.get_file()
