class_name OsWindow
extends PanelContainer


signal drag_started(window: OsWindow)
signal drag_moved(window: OsWindow)
signal drag_ended(window: OsWindow)
signal clicked(window: OsWindow)
signal minimized(window: OsWindow)
signal closed(window: OsWindow)

var app: OsApp
var dragging := false

@onready var title_bar: PanelContainer = $VBoxContainer/TitleBar
@onready var title_label: Label = $VBoxContainer/TitleBar/HBoxContainer/Title
@onready var app_container: PanelContainer = $VBoxContainer/AppContainer


func _ready() -> void:
	gui_input.connect(_on_gui_input)
	title_bar.gui_input.connect(_on_title_bar_gui_input)


func setup(app_definition: OsAppDefinition) -> void:
	title_label.text = app_definition.name
	size = app_definition.default_size
	app = app_definition.scene.instantiate()
	app_container.add_child(app)
	app.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit(self)
			

func _on_title_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_started.emit(event.position)
			else:
				dragging = false
				drag_ended.emit(event.position)

	elif event is InputEventMouseMotion and dragging:
		position += event.relative
		drag_moved.emit(event.relative)


func _on_minimize_button_pressed() -> void:
	minimized.emit(self)


func _on_close_button_pressed() -> void:
	closed.emit(self)
