extends Node


var high_score: float = 0
var score: float = 0
var multiplier: float = 1:
	set(value):
		multiplier = max(1, value)


@onready var player: Player = get_node("/root/World/Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_save()
	
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player:
		player = get_node("/root/World/Player")
	
	multiplier -= 0.1 * delta


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save()


func _unhandled_input(event: InputEvent) -> void:
	if event.as_text() == "Escape":
		save()
		get_tree().quit()
	elif event.as_text() == "R":
		restart()


func add_score(value: float) -> void:
	score += value * multiplier
	high_score = max(high_score, score)


func restart() -> void:
	score = 0
	multiplier = 1
	
	get_tree().reload_current_scene()


func save() -> void:
	var config_file: ConfigFile = ConfigFile.new()
	
	config_file.set_value("Game", "high_score", high_score)
	
	config_file.save_encrypted_pass("user://save_file.bin", "very secret password")


func load_save() -> void:
	var config_file: ConfigFile = ConfigFile.new()
	config_file.load_encrypted_pass("user://save_file.bin", "very secret password")
	
	high_score = config_file.get_value("Game", "high_score", high_score)
