extends Node3D

@export var obstacle_scenes: Array[PackedScene] = []
@export var count: int = 150
@export var min_distance: float = 5.0
@export var lateral_jitter_x: float = 10.0
@export var lateral_jitter_z: float = 5.0
@export var path_node: NodePath
@export var y_level: float = 0.0  # Adjustable height per map

var positions := []
var path: Path3D

func _ready():
	randomize()
	path = get_node(path_node)

	for i in range(count):
		var position = get_valid_position()
		if position != Vector3.ZERO:
			spawn_obstacle(position)

func get_valid_position() -> Vector3:
	var max_attempts = 50
	for attempt in range(max_attempts):
		var distance = randf_range(0, path.curve.get_baked_length())
		var pos = path.curve.sample_baked(distance)

		# Apply jitter (X and Z)
		pos.x += randf_range(-lateral_jitter_x, lateral_jitter_x)
		pos.z += randf_range(-lateral_jitter_z, lateral_jitter_z)

		# Set Y-level based on export value
		pos.y = y_level

		var valid = true
		for existing in positions:
			if pos.distance_to(existing) < min_distance:
				valid = false
				break

		if valid:
			positions.append(pos)
			return pos

	return Vector3.ZERO

func spawn_obstacle(position: Vector3):
	if obstacle_scenes.is_empty():
		return

	var scene = obstacle_scenes[randi() % obstacle_scenes.size()]
	if scene == null:
		return

	var instance = scene.instantiate()
	instance.global_position = position
	instance.rotation.y = randf_range(0, TAU)

	var random_scale = randf_range(1.2, 2.0)
	instance.scale = Vector3(random_scale, random_scale, random_scale)

	add_child(instance)
