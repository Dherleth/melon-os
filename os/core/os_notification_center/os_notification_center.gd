class_name OsNotificationCenter
extends PanelContainer

@onready var popups_container: VBoxContainer = $ScrollContainer/MarginContainer/PopupsContainer

var notification_popup_scene := preload("res://os/core/os_notification_center/os_notification_popup.tscn")

func _ready() -> void:
	hide()
	
	
func add_notification(text: String) -> void:
	show()
	var popup_instance = notification_popup_scene.instantiate() as OsNotificationPopup
	
	popups_container.add_child(popup_instance)
	popup_instance.text = text
	
	popup_instance.pressed.connect(remove_notification.bind(popup_instance))
	
	
func remove_notification(popup: OsNotificationPopup) -> void:
	# 1 because the last popup is not freed yet but will be
	if popups_container.get_children().size() <= 1:
		hide()
