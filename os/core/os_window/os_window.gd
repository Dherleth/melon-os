class_name OsWindow
extends PanelContainer

signal drag_started(window: OsWindow)
signal drag_moved(window: OsWindow)
signal drag_ended(window: OsWindow)
signal clicked(window: OsWindow)
signal focused(window: OsWindow)
signal minimized(window: OsWindow)
signal closed(window: OsWindow)

var app_instance: OsAppScene
var dragging := false

@onready var title_bar: PanelContainer = $VBoxContainer/TitleBar
@onready var title_label: Label = $VBoxContainer/TitleBar/MarginContainer/HBoxContainer/Title
@onready var app_container: PanelContainer = $VBoxContainer/AppContainer


func _ready() -> void:
	gui_input.connect(_on_gui_input)
	title_bar.gui_input.connect(_on_title_bar_gui_input)


func setup(app_instance_p: OsAppScene) -> void:
	app_instance = app_instance_p
	title_label.text = app_instance.get_window_name()
	size = app_instance.app_definition.default_size
	app_instance.os_window = self
	app_container.add_child(app_instance)
	app_instance.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	app_instance.focused.connect(_on_app_focused)
	

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			focused.emit(self)
			clicked.emit(self)
			
			
func _on_app_focused(app_instance: OsAppScene) -> void:
	focused.emit(self)
	clicked.emit(self)
			

func _on_title_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				focused.emit(self)
				drag_started.emit(event.position)
			else:
				dragging = false
				drag_ended.emit(event.position)

	elif event is InputEventMouseMotion and dragging:
		position += event.relative
		focused.emit(self)
		drag_moved.emit(event.relative)


func _on_minimize_button_pressed() -> void:
	minimize()


func _on_close_button_pressed() -> void:
	close()


func focus() -> void:
	show()
	focused.emit(self)
	

func minimize() -> void:
	hide()
	minimized.emit(self)
	
	
func close() -> void:
	hide()
	closed.emit(self)
	queue_free()
	
