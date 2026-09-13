class_name OsTaskBar
extends PanelContainer

@onready var app_buttons_container: HBoxContainer = $HBoxContainer/AppButtonsContainer
@onready var time_button: Button = $HBoxContainer/TimeButton

var app_button_scene: PackedScene = preload("res://os/core/os_task_bar/app_button/os_task_bar_app_button.tscn")


func _process(_delta: float) -> void:
	time_button.text = str(Time.get_time_dict_from_system()["hour"]) + ":" + str(Time.get_time_dict_from_system()["minute"]).pad_zeros(2)


func add_app_button(app_instance: OsAppScene) -> void:
	var app_button := app_button_scene.instantiate() as OsTaskBarAppButton
	app_button.setup(app_instance.app_definition.icon, app_instance.os_window)
	app_button.set_pressed_no_signal(true)
	app_buttons_container.add_child(app_button)


func set_app_buttons_focus(app_window: OsWindow) -> void:
	for button in app_buttons_container.get_children():
		if button.app_window == app_window:
			button.set_pressed_no_signal(true)
		else:
			button.set_pressed_no_signal(false)
