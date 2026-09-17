class_name OsAppScene
extends Control

signal focused(app_instance: OsAppScene)

var os_system: OsSystem
var os_window: OsWindow # The window containing the app instance
var app_definition: OsAppDefinition

# The file that launched the app.
# The file contains all the infos for the app and the app should know how to open it
# and read it.
# And as dev, you know in which manner to write the data in the file for a specific app.
var file_path := ""


# Overriden by children classes
func setup() -> void:
	pass
	

# Defaults to the file that opened the app. Child classes can override this
func get_window_name() -> String:
	var filename = file_path.get_file()
	var metadata_start := filename.find("_meta_")
	
	if metadata_start != -1:
		filename = filename.substr(0, metadata_start) + "." + filename.get_extension()
		
	return filename
