extends Camera3D

@export_node_path("Node3D") var target_path: NodePath
@export var follow_distance := 10.0
@export var follow_height := 4.0
@export var camera_lag := 5.0
@export var look_at_lag := 10.0

var target: Node3D
var velocity := Vector3.ZERO

func _ready():
	if target_path != NodePath():
		target = get_node_or_null(target_path)

func _physics_process(delta: float) -> void:
	if not target:
		return

	var target_transform := target.global_transform
	var target_position := target_transform.origin
	var target_forward := -target_transform.basis.z.normalized()

	# Desired camera position (behind and above the target)
	var desired_position := target_position - target_forward * follow_distance
	desired_position.y += follow_height

	# Smoothly move the camera toward the desired position
	global_position = global_position.lerp(desired_position, delta * camera_lag)

	# Smoothly rotate to look at the target
	var desired_look = (target_position - global_position).normalized()
	var current_basis = global_transform.basis
	var target_basis = Basis().looking_at(desired_look, Vector3.UP)
	global_transform.basis = current_basis.slerp(target_basis, delta * look_at_lag)
