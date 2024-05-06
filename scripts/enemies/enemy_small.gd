extends Enemy

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
#var last_tried_jump_velocity: float = 0


func _physics_process(delta: float) -> void:
	if not GameManager.player:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity += (GameManager.player.position - position).normalized() * speed * delta
	
		if is_on_wall():
			velocity = (GameManager.player.position - position).normalized() * speed * 25 * delta
			velocity.y = 7
			
			# Dynamic jump velocity. A little buggy. Uncomment when needed.
			#if velocity.y > 0 and last_tried_jump_velocity:
				#velocity.y = last_tried_jump_velocity
			#else:
				#if not last_tried_jump_velocity:
					#velocity.y = 7
				#else:
					#velocity.y = last_tried_jump_velocity * 1.5
				#
				#last_tried_jump_velocity = velocity.y
	
	if position.distance_to(GameManager.player.position) > 100:
		velocity = (GameManager.player.position - position).normalized() * speed * 100 * delta
		velocity.y = 0
	
	move_and_slide()
