class_name FileButton
extends Button

@onready var filename_label: Label = $MarginContainer/HBoxContainer/FilenameLabel
@onready var type_label: Label = $MarginContainer/HBoxContainer/TypeLabel
@onready var creation_date_label: Label = $MarginContainer/HBoxContainer/CreationDateLabel
@onready var size_label: Label = $MarginContainer/HBoxContainer/SizeLabel

const FILE_TYPE := {
	"png": "image file",
	"jpg": "image file",
	"jpeg": "image file",
	"webp": "image file",
	"gif": "image file",

	"txt": "text file",
	"md": "text file",

	"mp3": "sound file",
	"wav": "sound file",
	"ogg": "sound file",
}


# Of the form "name-creationDate-sizeInKo.extension"
func setup(filename_p: String) -> void:
	var parts := filename_p.split("-")
	var extension := filename_p.get_extension().to_lower()
	var filename := filename_p
	var type := ""
	var creation_date := ""
	var size_txt := ""
	
	if extension == "":
		type = "folder"

	if parts.size() > 1:
		filename = parts[0] + "." + extension
		
		if parts[1].length() >= 4:
			creation_date = parts[1].substr(0,2) + "." + parts[1].substr(2,2) + "." + parts[1].substr(4)


	if FILE_TYPE.has(extension):
		type = FILE_TYPE[extension]
		
	
	if parts.size() > 2:
		size_txt = parts[2].split(".")[0] + "ko"
	
	
	filename_label.text = filename
	type_label.text = type
	creation_date_label.text = creation_date
	size_label.text = size_txt
	
	
 
