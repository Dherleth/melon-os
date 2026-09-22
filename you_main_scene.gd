extends Control

@export var os_scene: PackedScene
@onready var button: Button = $Button

var os_instance : OsSystem

func _on_button_pressed() -> void:
	if os_scene:
		button.hide()
		os_instance = os_scene.instantiate() as OsSystem
		add_child(os_instance)
		os_instance.turned_off.connect(_on_os_turned_off)
		os_instance.turn_on()


func _on_os_turned_off() -> void:
	os_instance.queue_free()
	button.show()
