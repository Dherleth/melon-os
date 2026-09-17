class_name FileButton
extends Button

@onready var filename_label: Label = $MarginContainer/HBoxContainer/FilenameLabel
@onready var type_label: Label = $MarginContainer/HBoxContainer/TypeLabel
@onready var creation_date_label: Label = $MarginContainer/HBoxContainer/CreationDateLabel
@onready var size_label: Label = $MarginContainer/HBoxContainer/SizeLabel
@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var margin_container: MarginContainer = $MarginContainer

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
	
	"": "folder"
}

# filename_p can be a standard filename and will be displayed as it is in the project structure,
# with no metadata.
# Or we can specify custom metadata as:
# my_file_name_meta_created01012001size100ko.txt
#
# the filename will be: my_file_name.txt,
# the creation date will be: 01.01.2001,
# the size will be: 100ko
#
# If with_details is false, we hide all the labels except the filename.
# This is usefull for displaying folders in the file explorer tree, or desktop buttons
# for example.
#
# Spaces is used to show indentation in the file explorer tree
func setup(filepath: String, with_details := true, spaces := 0) -> void:
	if spaces > 0:
		var count = spaces
		while count != 0:
			var spacer = Label.new()
			h_box_container.add_child(spacer)
			h_box_container.move_child(spacer, 0)
			count = count - 1
			
	type_label.text = ""
	creation_date_label.text = ""
	size_label.text = ""
	
	var filename := filepath.get_file()
	var extension := filename.get_extension().to_lower()

	if FILE_TYPE.has(extension):
		type_label.text = FILE_TYPE[extension]
	
	var metadata_start = filename.find("_meta_")
	
	if metadata_start == -1:
		# This is a standard filename
		filename_label.text = filename
		
		if with_details:
			# We don't read metadata for standard filename
			size_label.text = _get_file_size(filepath)
		else:
			filename_label.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
			type_label.hide()
			creation_date_label.hide()
			size_label.hide()
	else:
		# The filename is formatted with custom metadata
		
		# Rebuilds the filename without metadata
		
		filename_label.text = filename.substr(0, metadata_start)
		if extension != "":
			filename_label.text = filename_label.text + "." + extension
			
		if with_details:
			# Isolates metadata from the filename
			var metadata := filename.substr(metadata_start + "_meta_".length())
			
			# removes the extension from the metadata
			if extension != "":
				metadata = metadata.split(".")[0]
			
			var creation_date_start = metadata.find("created")
			
			if creation_date_start != -1:
				var date_format_length = "01012001".length()
				var creation_date = metadata.substr(creation_date_start + "created".length(), date_format_length)
				
				if creation_date.length() == date_format_length:
					creation_date_label.text = creation_date.substr(0,2) + "." + creation_date.substr(2,2) + "." + creation_date.substr(4)
				
			var size_start = metadata.find("size")
			
			if size_start != -1:
				# We search for the end of the size string
				var recognized_sizes := ["ko", "kb", "mo", "mb", "go", "gb"]
				var size_str = metadata.substr(size_start + "size".length()).to_lower()

				for recognized_size in recognized_sizes:
					if size_str.contains(recognized_size):
						var size_end = size_str.find(recognized_size)
						# Resubstr in case there was an uppercase in the size
						size_str = metadata.substr(size_start + "size".length(), size_end + recognized_size.length())
						size_label.text = size_str
						break
			else:
				size_label.text = _get_file_size(filepath)
		else:
			filename_label.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
			type_label.hide()
			creation_date_label.hide()
			size_label.hide()

	# For scrollbar to appear if placed inside a scrollbar containers.
	# We wait for the sizes to be updated at runtime
	await get_tree().process_frame
	
	# Root node does not update it's size automatically when content changes
	self.custom_minimum_size.x = margin_container.size.x


func _get_file_size(file_path) -> String:
	var size_txt := ""
	var bytes := -1
	
	if FileAccess.file_exists(file_path):
		bytes = FileAccess.get_size(file_path)
	elif DirAccess.dir_exists_absolute(file_path):
		# We don't display size for directories
		return ""

	var bytes_f := float(bytes)
	var units := ["B", "KB", "MB", "GB"]
	var unit_index := 0

	while bytes_f >= 1024.0 and unit_index < units.size() - 1:
		bytes_f /= 1024.0
		unit_index += 1

	if bytes_f - int(bytes_f) == 0:
		return "%.0f %s" % [bytes_f, units[unit_index]]

	return "%.1f %s" % [bytes_f, units[unit_index]]
