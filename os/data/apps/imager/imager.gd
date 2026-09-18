extends OsAppScene

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect

func setup() -> void:
	open_file(file_path)
	

func open_file(file_path: String) -> void:
	var texture: Texture2D = load(file_path)
	texture_rect.texture = texture
	var window_size = texture.get_size()
	os_window.set_app_container_size(window_size)
	
	if window_size.y >= (os_window.get_viewport_rect().size.y / 2.0 + 100):
		os_window.position = Vector2i(os_window.position.x, randi_range(2, 5))


func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			focused.emit(self)
