extends OsAppScene

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel


func setup() -> void:
	open_file(file_path)
	

func open_file(file_path: String) -> void:
	var file := FileAccess.open(file_path, FileAccess.READ)
	
	if file == null:
		return
		
	var text := file.get_as_text()
	rich_text_label.text = text
	

func _on_rich_text_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			focused.emit(self)
