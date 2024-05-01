class_name Weapon
extends Node3D


@export var damage: float
var is_attacking: bool


@onready var enemy_hurt_hitbox: Area3D = $EnemyHurtHitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _equip() -> void:
	pass


func _unequip() -> void:
	pass


func _attack() -> void:
	pass


func _on_area_3d_body_entered(enemy: Enemy) -> void:
	if not is_attacking:
		return
	
	enemy.health -= damage
