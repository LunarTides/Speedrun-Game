class_name Enemy
extends CharacterBody3D


const ENEMY_TARGET_MATERIAL: Material = preload("res://scenes/enemies/enemy_target_material.tres")


@export var speed: float = 25
@export var damage: float = 25
@export var health: float = 25:
	set(value):
		health = value
		
		hit.emit()
		
		if health <= 0:
			queue_free()


@onready var target_indicator: MeshInstance3D = $TargetIndicator
@onready var target_indicator_animation_player: AnimationPlayer = $TargetIndicator/AnimationPlayer

var paused: bool = false
var bound: bool = false
var antigrav: bool = false

signal hit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit.connect(func() -> void:
		$HitParticles.restart()
		
		GameManager.add_score(1)
		GameManager.multiplier += 0.1
	)
	
	$MeshInstance3D.get_active_material(0).cull_mode = BaseMaterial3D.CULL_DISABLED


func mark_as_target() -> void:
	if not is_inside_tree():
		return
	
	$MeshInstance3D.set_surface_override_material(0, ENEMY_TARGET_MATERIAL)
	
	target_indicator.show()
	await get_tree().create_timer(1.0).timeout
	target_indicator_animation_player.play(&"dance")


func unmark_as_target() -> void:
	$MeshInstance3D.set_surface_override_material(0, null)
	
	target_indicator.hide()
	target_indicator_animation_player.stop()
