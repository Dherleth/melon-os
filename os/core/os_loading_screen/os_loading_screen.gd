class_name OsLoadingScreen
extends Control

signal finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func start():
	animation_player.play("load")
	await animation_player.animation_finished
	
	finished.emit()
