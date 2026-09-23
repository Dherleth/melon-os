extends Control

@onready var button: Button = $Button

func _on_button_pressed() -> void:
	button.hide()
	
	var os_instance := OsSystem.create()
	os_instance.turned_off.connect(_on_os_turned_off)
	
	add_child(os_instance)
	os_instance.turn_on()


func _on_os_turned_off(os_instance: OsSystem) -> void:
	os_instance.queue_free()
	button.show()
