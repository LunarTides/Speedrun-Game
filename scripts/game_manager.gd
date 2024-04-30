extends Node


@onready var player: Player = get_node("/root/World/Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player:
		player = get_node("/root/World/Player")


func _unhandled_input(event: InputEvent) -> void:
	if event.as_text() == "Escape":
		get_tree().quit()
	elif event.as_text() == "R":
		get_tree().reload_current_scene()
