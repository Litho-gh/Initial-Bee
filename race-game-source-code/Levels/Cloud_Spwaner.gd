extends CSGBox3D

@export var clouds_to_spawn : int = 10
@export var _cloud : PackedScene

var rng = RandomNumberGenerator.new()

func _ready():
	if _cloud == null:
		push_error("_cloud PackedScene not assigned!")
		return
	spawn_clouds()

func spawn_clouds():
	for i in range(clouds_to_spawn):
		var x = rng.randf_range(-size.x / 2, size.x / 2)
		var y = rng.randf_range(-size.y / 2, size.y / 2)
		var z = rng.randf_range(-size.z / 2, size.z / 2)

		var spawn_pos = Vector3(x, y, z)
		var cloud = _cloud.instantiate()
		add_child(cloud)
		cloud.global_position = self.global_position + spawn_pos
