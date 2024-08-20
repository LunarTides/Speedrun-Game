extends Button


@export var action: StringName


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(false)
	update_key_text()


func _input(event: InputEvent) -> void:
	if event.is_released():
		return
	
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	button_pressed = false


func _on_toggled(toggled_on: bool) -> void:
	set_process_input(toggled_on)
	
	if toggled_on:
		text = "... PRESS ANY BUTTON ..."
		release_focus()
	else:
		update_key_text()
		grab_focus()


func update_key_text() -> void:
	text = "%s" % InputMap.action_get_events(action)[0].as_text().replace(" (Physical)", "")
