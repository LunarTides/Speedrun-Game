extends Weapon


var color: float = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var particle_material: Material = Material.new()
	#particle_material.albedo_color = Color.from_ok_hsl(delta, 100, 59)
	color += 0.5 * delta
	
	$GPUParticles3D.draw_pass_1.surface_get_material(0).albedo_color = Color.from_ok_hsl(color, 0.4, 0.4)
	
	if color >= 1:
		color = 0


func _unhandled_input(event: InputEvent) -> void:
	var player: Player = GameManager.player
	
	if not player:
		return
	
	if not player.equipped_weapon == self:
		return
	
	if event.is_action("fly_to_enemy"):
		var enemy: Enemy = player.enemy_target
		if not enemy:
			return
		
		player.can_be_damaged = false
		
		var diff: Vector3 = Vector3(1000, 1000, 1000)
		
		while ((diff / 20).length() > 5):
			diff = (enemy.global_position - player.global_position) * 20
			
			player.extra_velocity.x += diff.x
			player.extra_velocity.z += diff.z
			player.extra_velocity.y += diff.y / 20
			
			await get_tree().physics_frame
		
		await get_tree().create_timer(0.5).timeout
		player.can_be_damaged = true


func _equip() -> void:
	show()
	animation_tree.get("parameters/playback").travel(&"equip")


func _unequip() -> void:
	hide()


func _attack() -> void:
	is_attacking = true
	
	var playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
	
	playback.stop()
	playback.start(&"attack")
	
	await get_tree().create_timer(0.5).timeout
	
	is_attacking = false
