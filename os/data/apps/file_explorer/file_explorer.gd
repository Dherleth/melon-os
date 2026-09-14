extends OsAppScene

@onready var folder_content_list: VBoxContainer = $MarginContainer2/HBoxContainer/ScrollContainer/FolderContentList
@onready var folders_list: VBoxContainer = $MarginContainer2/HBoxContainer/ScrollContainer2/FoldersList

var file_button_scene := preload("res://os/data/apps/file_explorer/file_button.tscn")


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
				var file_button_instance := file_button_scene.instantiate() as FileButton
				folder_content_list.add_child(file_button_instance)
				file_button_instance.setup(full_path.get_file())
				file_button_instance.pressed.connect(_on_file_button_pressed.bind(full_path))
				print("FILE: ", full_path)

		entry = dir.get_next()

	dir.list_dir_end()


func get_window_name() -> String:
	return app_definition.name
	
	

func _on_file_button_pressed(file_path: String) -> void:
	os_system.open_file(file_path)
