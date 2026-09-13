extends OsAppScene


func _ready() -> void:
	scan_directory("res://os/data/filesystem")
	
	
func scan_directory(path: String) -> void:
	var dir := DirAccess.open(path)
	
	if dir == null:
		return
	
	dir.list_dir_begin()
	
	var entry := dir.get_next()
	
	while entry != "":
		if entry != "." and entry != "..":
			var full_path := path.path_join(entry)

			if dir.current_is_dir():
				print("DIR: ", full_path)
				scan_directory(full_path)
			else:
				print("FILE: ", full_path)

		entry = dir.get_next()

	dir.list_dir_end()


func get_window_name() -> String:
	return app_definition.name
