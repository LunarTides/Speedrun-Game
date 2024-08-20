extends Node3D

@export var speed: float = 30

var target_1: Enemy
var target_2: Enemy
var connected_num: int = 0

var antigrav: bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_instance_valid(target_1) or (connected_num == 2 and not is_instance_valid(target_2)):
		if visible:
			stop()
		return
	
	if connected_num == 1:
		draw_line(global_position, target_1.position)
		
		target_1.velocity += (global_position - target_1.position) * delta * 4
	elif connected_num == 2:
		draw_line(target_2.position, target_1.position)
		
		target_1.velocity += (target_2.global_position - target_1.global_position) * delta * 15
		target_2.velocity += (target_1.global_position - target_2.global_position) * delta * 15


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("rope_antigrav"):
		# Play fancy sfx and vfx
		antigrav = not antigrav
		
		if target_1:
			target_1.antigrav = antigrav
		if target_2:
			target_2.antigrav = antigrav


func target(enemy: Enemy) -> void:
	if not is_instance_valid(enemy) and connected_num != 2:
		return
	
	if enemy == target_1 or enemy == target_2:
		stop()
		return
	
	show()
	
	if connected_num == 2:
		stop()
		
		if not enemy:
			return
	
	if enemy:
		show()
		enemy.bound = true
		enemy.antigrav = antigrav
	
	connected_num += 1
	
	if connected_num == 1:
		target_1 = enemy
	elif connected_num == 2:
		target_2 = enemy


func stop() -> void:
	hide()
	connected_num = 0
	if target_1:
		target_1.bound = false
		target_1.antigrav = false
	if target_2:
		target_2.bound = false
		target_2.antigrav = false
	target_1 = null
	target_2 = null


func draw_line(pos1: Vector3, pos2: Vector3) -> void:
	var mesh_instance: MeshInstance3D = MeshInstance3D.new()
	var immediate_mesh: ImmediateMesh = ImmediateMesh.new()
	var material: ORMMaterial3D = ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK

	get_tree().get_root().add_child(mesh_instance)
	await get_tree().physics_frame
	mesh_instance.queue_free()
