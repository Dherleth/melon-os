class_name FileExplorerApp
extends OsApp

@onready var path_label: Label = $VBoxContainer/PathLabel
@onready var file_list: VBoxContainer = $VBoxContainer/FileList

var current_path := "/"


func start() -> void:
	refresh()


func refresh() -> void:
	path_label.text = current_path

	for child in file_list.get_children():
		child.queue_free()

	var directory := os.file_system.get_directory(
		current_path
	)

	if directory == null:
		return

	var entries := os.file_system.list_directory(
		current_path
	)

	for entry in entries:
		var button := Button.new()

		if entry is OSDirectory:
			button.text = "📁 " + entry.name
		else:
			button.text = "📄 " + entry.name

		file_list.add_child(button)
