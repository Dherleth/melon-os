class_name OsDesktopButton
extends Button

@onready var filename_label: Label = $MarginContainer/VBoxContainer/FilenameLabel
@onready var texture_rect: TextureRect = $MarginContainer/VBoxContainer/TextureRect


var full_path := ""


func setup(filepath: String, icon: Texture2D) -> void:
	texture_rect.texture = icon
	full_path = filepath
	
	var filename := filepath.get_file()
	var extension := filename.get_extension().to_lower()
	
	var metadata_start = filename.find("_meta_")
	
	if metadata_start == -1:
		# This is a standard filename
		filename_label.text = filename
	else:
		# The filename has custom metadata
		# Rebuilds the filename without metadata
		filename_label.text = filename.substr(0, metadata_start)
		if extension != "":
			filename_label.text = filename_label.text + "." + extension
