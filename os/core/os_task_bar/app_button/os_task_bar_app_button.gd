class_name OsTaskBarAppButton
extends Button

var app_window: OsWindow


func setup(app_icon: Texture2D, app_window_p: OsWindow) -> void:
	icon = app_icon
	app_window = app_window_p
	
	app_window.minimized.connect(_on_window_minimized)
	app_window.closed.connect(_on_window_closed)


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		app_window.focus()
	else:
		app_window.minimize()
		
		
func _on_window_minimized(_window: OsWindow) -> void:
	set_pressed_no_signal(false)
	

func _on_window_closed(_window: OsWindow) -> void:
	queue_free()
