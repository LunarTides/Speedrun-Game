extends Enemy


const ENEMY_TARGET_MATERIAL: Material = preload("res://scenes/enemy_target_material.tres")
const SPEED: float = 25.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var target_indicator: MeshInstance3D = $TargetIndicator
@onready var target_indicator_animation_player: AnimationPlayer = $TargetIndicator/AnimationPlayer


func _ready() -> void:
	hit.connect(func() -> void:
		$HitParticles.restart()
	)
	
	$MeshInstance3D.get_active_material(0).cull_mode = BaseMaterial3D.CULL_DISABLED


func _physics_process(delta: float) -> void:
	if not GameManager.player:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity += (GameManager.player.position - position).normalized() * SPEED * delta
	
	if position.distance_to(GameManager.player.position) > 100:
		velocity = (GameManager.player.position - position).normalized() * SPEED * 100 * delta
		velocity.y = 0
	
	move_and_slide()


func mark_as_target() -> void:
	$MeshInstance3D.set_surface_override_material(0, ENEMY_TARGET_MATERIAL)
	
	target_indicator.show()
	await get_tree().create_timer(1.0)
	target_indicator_animation_player.play(&"dance")


func unmark_as_target() -> void:
	$MeshInstance3D.set_surface_override_material(0, null)
	
	target_indicator.hide()
	target_indicator_animation_player.stop()
