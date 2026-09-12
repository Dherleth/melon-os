class_name OsTaskBar
extends PanelContainer

@onready var app_buttons_container: HBoxContainer = $AppButtonsContainer

var app_button_scene: PackedScene = preload("res://os/core/os_task_bar/app_button/os_task_bar_app_button.tscn")

func _ready() -> void:
	OsSystem.app_manager.task_bar = self
	OsSystem.app_manager.launch_app(OsSystem.os_definition.apps[0].id)
	
	
func add_app_button(app_instance: OsAppScene) -> void:
	var app_button = app_button_scene.instantiate() as OsTaskBarAppButton
	app_button.setup(app_instance.app_definition.icon, app_instance.os_window)
	app_button.set_pressed_no_signal(true)
	app_buttons_container.add_child(app_button)
