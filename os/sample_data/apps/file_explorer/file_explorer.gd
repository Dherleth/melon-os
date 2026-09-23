extends OsAppScene

@onready var folder_content_list: VBoxContainer = $MarginContainer2/HBoxContainer/ScrollContainer/FolderContentList
@onready var folders_list: VBoxContainer = $MarginContainer2/HBoxContainer/ScrollContainer2/FoldersList
@onready var path_input: LineEdit = $MarginContainer/PathInput

var file_button_scene := preload("res://os/sample_data/apps/file_explorer/file_button.tscn")
var fake_fs_base_path := "M://"

func setup() -> void:
	_set_path_input_text(file_path)
	
	# Setup the explorer to know all the fs
	scan_directory(os_system.os_definition.filesystem_base_path, true)
	
	# Sets the explorer to be on the directory that opened it
	scan_directory(file_path)
	
	_update_tree_current_folder()
	
	
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
					var icon = os_system.get_file_app_association(full_path).icon
					file_button_instance.setup(full_path, icon)
					file_button_instance.pressed.connect(_on_file_button_pressed.bind(full_path))
				
				if recursive:
					# We are scanning the whole fs to show the tree
					if dir.current_is_dir():
						var file_button_instance := file_button_scene.instantiate() as FileButton
						folders_list.add_child(file_button_instance)
						var icon = os_system.get_file_app_association(full_path).icon
						file_button_instance.setup(full_path, icon, false, level)
						file_button_instance.pressed.connect(_on_file_button_pressed.bind(full_path))
						scan_directory(full_path, recursive, level + 1)

		entry = dir.get_next()

	dir.list_dir_end()


func get_window_name() -> String:
	return app_definition.name
	
	
func _on_file_button_pressed(file_path_p: String) -> void:
	# If it is a folder we don't ask the OS to open it, because it would launch
	# a new instance of the file explorer. We want to stay in the current one
	focused.emit(self)
	
	if file_path_p.get_extension() == "":
		_set_path_input_text(file_path_p)
		
		scan_directory(file_path_p)
		_update_tree_current_folder()
	else:
		os_system.open_file(file_path_p)
	

func _set_path_input_text(path: String) -> void:
	# Hides the project structure from the player, hiding the path to the fs base path
	path_input.text = path.replace(os_system.os_definition.filesystem_base_path, fake_fs_base_path)


func _on_path_input_text_submitted(fake_path: String) -> void:
	var real_path = fake_path.replace(fake_fs_base_path, os_system.os_definition.filesystem_base_path)
	
	scan_directory(real_path)
	_update_tree_current_folder()
	
	
func _update_tree_current_folder() -> void:
	var current_folder_path = path_input.text.replace(fake_fs_base_path, os_system.os_definition.filesystem_base_path)
	
	for button in folders_list.get_children():
		var file_button = button as FileButton
		
		if file_button.full_path.rstrip("/") == current_folder_path.to_lower().rstrip("/"):
			file_button.set_as_current()
		else:
			file_button.set_as_not_current()
			

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				focused.emit(self)


func _on_path_input_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				focused.emit(self)
