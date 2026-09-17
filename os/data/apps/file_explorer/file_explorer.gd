extends OsAppScene

@onready var folder_content_list: VBoxContainer = $MarginContainer2/HBoxContainer/ScrollContainer/FolderContentList
@onready var folders_list: VBoxContainer = $MarginContainer2/HBoxContainer/ScrollContainer2/FoldersList
@onready var path_input: LineEdit = $MarginContainer/PathInput

var file_button_scene := preload("res://os/data/apps/file_explorer/file_button.tscn")
var fake_fs_base_path := "M://"

func setup() -> void:
	_set_path_input_text(file_path)

	scan_directory(file_path, true)
	
	
# Shows the content of the directory that:
# 1. opened the file explorer or
# 2. that was clicked in the file explorer
#
# If 1, we set recursive to true to go through the whole tree and show the fs tree
# on the left (only directories).
func scan_directory(path: String, recursive := false, level := 0) -> void:
	# Prevents from opening paths that are not in the intended runtime path
	if not path.contains(os_system.os_definition.filesystem_base_path):
		return
	
	# Empties the content on the first pass
	if level == 0:
		for child in folder_content_list.get_children():
			child.queue_free()
		
	var dir := DirAccess.open(path)
	if dir == null:
		return
	
	dir.list_dir_begin()
	
	var entry := dir.get_next()
	
	while entry != "":
		if entry != "." and entry != "..":
			var is_authorized_extension = not os_system.os_definition.extensions_to_hide.has(entry.get_extension())
			
			if is_authorized_extension:
				var full_path := path.path_join(entry)
				
				if level == 0:
					# Shows the content of the directory
					var file_button_instance := file_button_scene.instantiate() as FileButton
					folder_content_list.add_child(file_button_instance)
					file_button_instance.setup(full_path)
					file_button_instance.pressed.connect(_on_file_button_pressed.bind(full_path))
				
				if recursive:
					# We are scanning the whole fs to show the tree
					if dir.current_is_dir():
						var file_button_instance := file_button_scene.instantiate() as FileButton
						folders_list.add_child(file_button_instance)
						file_button_instance.setup(full_path.get_file(), false, level)
						file_button_instance.pressed.connect(_on_file_button_pressed.bind(full_path))
						scan_directory(full_path, recursive, level + 1)

		entry = dir.get_next()

	dir.list_dir_end()


func get_window_name() -> String:
	return app_definition.name
	
	
func _on_file_button_pressed(file_path: String) -> void:
	# If it is a folder we don't ask the OS to open it, because it would launch
	# a new instance of the file explorer. We want to stay in the current one
	if file_path.get_extension() == "":
		_set_path_input_text(file_path)
		
		scan_directory(file_path)
	else:
		os_system.open_file(file_path)
	

func _set_path_input_text(path: String) -> void:
	# Hides the project structure from the player, hiding the path to the fs base path
	path_input.text = path.replace(os_system.os_definition.filesystem_base_path, fake_fs_base_path)


func _on_path_input_text_submitted(fake_path: String) -> void:
	var real_path = fake_path.replace(fake_fs_base_path, os_system.os_definition.filesystem_base_path)
	
	scan_directory(real_path)
