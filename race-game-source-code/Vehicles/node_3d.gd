extends Node3D

@export var smooth_speed = 5

var direction = Vector3.BACK

func _physics_process(delta):
	var current_velocity = get_parent().linear_velocity
	
	current_velocity.y = 0
	
	direction = lerp(direction, -current_velocity.normalized(), smooth_speed * delta)
	global_transform.basis = _get_relations_from_direction(direction)
	
func _get_relations_from_direction(look_direction: Vector3):
	look_direction = look_direction.normalized()
	var x_axis = look_direction.cross(Vector3.UP)
	
	return Basis(x_axis, Vector3.UP, -look_direction)
