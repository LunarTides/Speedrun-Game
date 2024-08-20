extends Node


const PAUSE_MENU: PackedScene = preload("res://scenes/ui/pause_menu.tscn")
const SETTINGS_MENU: PackedScene = preload("res://scenes/ui/settings_menu.tscn")

var high_score: float = 0
var score: float = 0:
	set(value):
		score = max(value, 0)
var multiplier: float = 1:
	set(value):
		multiplier = max(1, value)
var pause_menu: PanelContainer
var settings_menu: TabContainer


@onready var player: Player = get_node("/root/World/Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_save()
	
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	process_mode = PROCESS_MODE_ALWAYS
	
	add_global_menus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player:
		player = get_node("/root/World/Player")
	
	multiplier -= 0.1 * delta


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_released():
		return
	
	if event.as_text() == "Escape":
		if not is_instance_valid(pause_menu):
			return
		
		pause_menu.toggle()
	elif event.is_action(&"restart"):
		restart()


func add_score(value: float) -> void:
	if value > 0:
		score += value * multiplier
	else:
		# Don't use the multiplier when subtracting score.
		score += value
	
	high_score = max(high_score, score)


func restart() -> void:
	score = 0
	multiplier = 1
	
	get_tree().reload_current_scene()
	
	var time: float = 0.01
	
	await get_tree().create_timer(time).timeout
	assert(is_instance_valid(get_tree().current_scene), "The scene took longer than %s seconds to load. Make the timer longer." % time)
	
	add_global_menus()


func add_global_menus() -> void:
	pause_menu = PAUSE_MENU.instantiate()
	pause_menu.hide()
	get_tree().current_scene.add_child.call_deferred(pause_menu)
	
	settings_menu = SETTINGS_MENU.instantiate()
	settings_menu.hide()
	get_tree().current_scene.add_child.call_deferred(settings_menu)


func save() -> void:
	var config_file: ConfigFile = ConfigFile.new()
	
	config_file.set_value("Game", "high_score", high_score)
	
	config_file.save_encrypted_pass("user://save_file.bin", "very secret password")


func load_save() -> void:
	var config_file: ConfigFile = ConfigFile.new()
	config_file.load_encrypted_pass("user://save_file.bin", "very secret password")
	
	high_score = config_file.get_value("Game", "high_score", high_score)
