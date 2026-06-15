extends Control
@onready var settings: Panel = $settings
@onready var main_menu: Control = $main_menu
@onready var fullscreen_btn: Button = $settings/fullscreen_bg/fullscreen

func _ready() -> void:
	main_menu.visible = true
	settings.visible = false
	
	var mode = DisplayServer.window_get_mode()
	print("[Settings] Initial window mode: ", mode)
	if mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN or mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		fullscreen_btn.text = "Windowed"
	else:
		fullscreen_btn.text = "Fullscreen"

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://tscens/lvl1.tscn")


func _on_settings_pressed() -> void:
	main_menu.visible = false
	settings.visible = true


func _on_exit_pressed() -> void:
	get_tree().quit()
	


func _on_back_pressed() -> void:
	main_menu.visible = true
	settings.visible = false


func _on_fullscreen_pressed() -> void:
	print("[Settings] Fullscreen button clicked!")
	var mode = DisplayServer.window_get_mode()
	print("[Settings] Current mode before toggle: ", mode)
	if mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN or mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullscreen_btn.text = "Fullscreen"
		print("[Settings] Toggled to Windowed")
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullscreen_btn.text = "Windowed"
		print("[Settings] Toggled to Fullscreen")


