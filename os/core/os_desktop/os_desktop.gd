class_name OsDesktop
extends Control

@onready var columns_container: HBoxContainer = $MarginContainer/ColumnsContainer
@onready var buttons_container: VBoxContainer = $MarginContainer/ColumnsContainer/ButtonsContainer

var desktop_button_scene := preload("res://os/core/os_desktop/os_desktop_button.tscn")
var os_system: OsSystem

func setup() -> void:
	var desktop_folder = _find_desktop_folder(os_system.os_definition.filesystem_base_path)
	
	if desktop_folder:
		scan_directory(desktop_folder)
	else:
		printerr("No 'desktop' folder found")


func scan_directory(path: String) -> void:
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
				
				# Shows the content of the directory
				var desktop_button_instance := desktop_button_scene.instantiate() as OsDesktopButton
				buttons_container.add_child(desktop_button_instance)
				
				var associated_app := os_system.get_file_app_association(full_path)
				var icon = null
				
				if associated_app:
					icon = associated_app.icon
					
				desktop_button_instance.setup(full_path, icon)
				desktop_button_instance.pressed.connect(_on_desktop_button_pressed.bind(full_path))
				
				if buttons_container.get_children().size() == os_system.os_definition.desktop_icons_per_column:
					var new_container = VBoxContainer.new()
					new_container.add_theme_constant_override("separation", 40)
					columns_container.add_child(new_container)
					buttons_container = new_container
					
			
		entry = dir.get_next()

	dir.list_dir_end()
	

func _on_desktop_button_pressed(file_path: String) -> void:
	os_system.open_file(file_path)
	
	
func _find_desktop_folder(fs_path: String, desktop_folder_name := "desktop") -> String:
	var dir := DirAccess.open(fs_path)

	if dir == null:
		return ""

	dir.list_dir_begin()

	while true:
		var name := dir.get_next()

		if name == "":
			break

		if dir.current_is_dir():
			if name == desktop_folder_name:
				return fs_path.path_join(name)

			var result := _find_desktop_folder(fs_path.path_join(name), desktop_folder_name)

			if result != "":
				return result

	dir.list_dir_end()
	return ""
