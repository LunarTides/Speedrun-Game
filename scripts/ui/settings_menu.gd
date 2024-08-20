extends TabContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for action: StringName in InputMap.get_actions():
		if action.begins_with("ui_"):
			continue
		
		if action.begins_with("debug_") and not OS.is_debug_build():
			continue
		
		var action_container: HSplitContainer = $Keybinds/VBoxContainer/HBoxContainer.duplicate()
		action_container.get_node("Label").text = action.to_pascal_case()
		action_container.get_node("KeybindButton").action = action
		$Keybinds/VBoxContainer.add_child(action_container)
		
	$Keybinds/VBoxContainer/HBoxContainer.queue_free()


func _input(event: InputEvent) -> void:
	if event.as_text() == "Escape":
		hide()
