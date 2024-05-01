extends Enemy

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	if not GameManager.player:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity += (GameManager.player.position - position).normalized() * speed * delta
	
	if position.distance_to(GameManager.player.position) > 100:
		velocity = (GameManager.player.position - position).normalized() * speed * 100 * delta
		velocity.y = 0
	
	move_and_slide()
