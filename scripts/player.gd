class_name Player
extends CharacterBody3D


const STARTING_SPEED: float = 7.0
const STARTING_EXTRA_JUMPS: int = 1
const JUMP_VELOCITY: float = 7
const SENSITIVITY: float = 0.3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed: float = STARTING_SPEED
var extra_jumps: int = STARTING_EXTRA_JUMPS
var is_moving: bool = false
var is_slamming: bool = false
var is_on_damage_cooldown: bool = false
var can_be_damaged: bool = true
var health: float = 100
var equipped_weapon: Weapon
var enemy_target: Enemy
var extra_velocity: Vector3
var slam_speed: float


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
		#GameManager.multiplier += max(0, speed / 300) * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or extra_jumps > 0):
		if not is_on_floor():
			extra_jumps -= 1
		
		velocity.y = JUMP_VELOCITY
		speed *= 1.05
	
	if is_on_floor():
		extra_jumps = STARTING_EXTRA_JUMPS
		
		if is_slamming:
			speed = max(speed, slam_speed)
			slam_speed = 0
			is_slamming = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		speed += 10 * delta
		speed *= 1 + (0.02 * delta)
	else:
		#velocity.x = move_toward(velocity.x, 0, speed)
		#velocity.z = move_toward(velocity.z, 0, speed)
		velocity.x = 0
		velocity.z = 0
	
	if Input.is_action_just_pressed("slam"):
		slam_speed = max(slam_speed, speed)
		
		if is_on_floor():
			# Convert horizontal to vertical.
			velocity.y = abs(velocity.x) + abs(velocity.y)
			velocity.x = 0
			velocity.z = 0
			speed = STARTING_SPEED
		else:
			# If the player is already slamming downwards, slam harder.
			if velocity.y < 0:
				velocity.y *= 2
			else:
				velocity.y = -JUMP_VELOCITY * 10
		is_slamming = true
	
	# If the player collides with a wall, reset their momentum.
	if is_on_wall():
		speed = STARTING_SPEED
	
	# If the player comes to a complete stop, give them a grace period to keep their momentum.
	if is_moving and (velocity.x == 0 or velocity.z == 0) and %CancelMomentumTimer.is_stopped():
		%CancelMomentumTimer.start()
	
	velocity += extra_velocity
	extra_velocity = Vector3.ZERO
	
	is_moving = abs(velocity.x) > 0 and abs(velocity.z) > 0
	
	move_and_slide()
	
	for i: int in get_slide_collision_count():
		var collision: KinematicCollision3D = get_slide_collision(i)
		var collider: Node = collision.get_collider()
		
		if not is_on_damage_cooldown and can_be_damaged and collider is Enemy and collider.is_in_group(&"DamageOnTouch"):
			health -= collider.damage
			is_on_damage_cooldown = true
			%DamageCooldown.start()
			
			if health <= 0:
				# TODO: Add more here.
				GameManager.restart()
	
	var new_enemy_target_collision: Node = %CameraRay.get_collider()
	var new_enemy_target: Enemy
	
	if new_enemy_target_collision:
		new_enemy_target = new_enemy_target_collision.get_parent()
	
	if not new_enemy_target_collision or new_enemy_target != enemy_target:
		if is_instance_valid(enemy_target):
			enemy_target.unmark_as_target()
			enemy_target = null
	
	if new_enemy_target:
		enemy_target = new_enemy_target
	
	if is_instance_valid(enemy_target):
		enemy_target.mark_as_target()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		%Camera.rotation_degrees.x -= event.relative.y * SENSITIVITY
		rotation_degrees.y -= event.relative.x * SENSITIVITY
		
		# Limit the camera's rotation.
		if abs(%Camera.rotation_degrees.x) > 90:
			%Camera.rotation_degrees.x = 90 * sign(%Camera.rotation_degrees.x)
	elif event.is_action_pressed("unequip_weapon"):
		if not equipped_weapon:
			# TODO: Play sound effect
			return
		
		equipped_weapon._unequip()
		equipped_weapon = null
	elif event.is_action_pressed("equip_katana"):
		if equipped_weapon:
			if equipped_weapon == %Katana:
				return
			
			equipped_weapon._unequip()
		
		%Katana._equip()
		equipped_weapon = %Katana
	elif event.is_action_pressed("attack"):
		if not equipped_weapon:
			# TODO: Play sound effect
			return
		
		equipped_weapon._attack()


func _on_cancel_momentum_timer_timeout() -> void:
	if velocity.x == 0 or velocity.z == 0:
		speed = STARTING_SPEED


func _on_damage_cooldown_timeout() -> void:
	is_on_damage_cooldown = false
