extends PanelContainer


func toggle() -> void:
	visible = not visible
	get_tree().paused = not get_tree().paused
	
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE if visible else DisplayServer.MOUSE_MODE_CAPTURED)


func _on_resume_button_pressed() -> void:
	toggle()


func _on_settings_button_pressed() -> void:
	GameManager.settings_menu.show()


func _on_quit_button_pressed() -> void:
	GameManager.save()
	get_tree().quit()
