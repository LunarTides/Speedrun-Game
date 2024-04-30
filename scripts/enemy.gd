class_name Enemy
extends CharacterBody3D


@export var damage: float
@export var health: float:
	set(value):
		health = value
		
		hit.emit()
		
		if health <= 0:
			queue_free()


signal hit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
