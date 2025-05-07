extends Node3D
class_name Level

@export var track: Path3D
@export var checkpoint: Area3D

var _players: Array[Player]
var _number_laps: int

const MAX_RACE_COUNTDOWN := 1
var race_countdown: float = MAX_RACE_COUNTDOWN
var is_race_started: bool = false

var level_ui: Control
var pause_menu: Control

var bg_music := AudioStreamPlayer.new()

# Constructor
func with_data(players: Array[Player], number_laps: int):
	self._players = players
	self._number_laps = number_laps
	return self

func _ready():
	# Always unpause and lock mouse when level starts
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	bg_music.stream = load("res://Sounds/city_track.wav")


	# Setup checkpoint listener
	checkpoint.body_entered.connect(_on_checkpoint_body_entered)
	(checkpoint as Area3D).collision_mask = 0b1111111111111111

	# Setup players
	spawn_players()
	pause_players_process()

	# Add Level UI
	level_ui = SceneManager.load_scene("res://Levels/UI/LevelUI.tscn")
	add_child(level_ui)

	# Add Pause Menu
	pause_menu = load("res://PauseMenu.tscn").instantiate()
	add_child(pause_menu)
	pause_menu.visible = false

func _input(event):
	if event.is_action_pressed("pause") and is_race_started:
		toggle_pause()

func toggle_pause():
	var paused := not get_tree().paused
	get_tree().paused = paused
	pause_menu.visible = paused

	if paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func spawn_players():
	var index: int = 0
	for player in _players:
		player.vehicle.position = get_tree().get_nodes_in_group("spawn_points")[index].global_position
		player.vehicle.look_at_from_position(
			player.vehicle.position,
			player.vehicle.position - get_track_direction(checkpoint.global_position),
			Vector3.UP
		)

		if player is HumanPlayer:
			player.name = "Hymenopteracer"
		else:
			player.name = "AI Player" + str(index)

		if player is AIPlayer:
			player.set_track(track)

		add_child(player)
		index += 1

func _on_checkpoint_body_entered(body):
	if not (body is Vehicle3D): return
	var player := body.get_parent() as Player

	if (player.get_distance_traveled() / (player.lap + 1)) >= 0.88 * get_track_length():
		player.next_lap()
		if player.lap >= _number_laps:
			player.finished = true

func get_track_length():
	return track.curve.get_baked_length()

func get_track_direction(at_position: Vector3):
	var offset := track.curve.get_closest_offset(at_position)
	var point_1 := track.curve.sample_baked(offset, true)
	var point_2 := track.curve.sample_baked(offset + 0.5, true)
	return (point_2 - point_1).normalized()

func _process(delta):
	if not is_race_started:
		if race_countdown < 0:
			is_race_started = true
			resume_players_process()
	else:
		if race_countdown < -1:
			level_ui.visible = false

	race_countdown -= delta

	if race_countdown > 0:
		level_ui.set_countdown_text(str(floor(race_countdown + 1)))
	else:
		level_ui.set_countdown_text("GO!")
	
	# Run music in process
	bg_music.autoplay = true
	bg_music.volume_db = -20
	add_child(bg_music)

func pause_players_process():
	for p in get_tree().get_nodes_in_group("players"):
		p.set_process(false)
		p.set_physics_process(false)

func resume_players_process():
	for p in get_tree().get_nodes_in_group("players"):
		p.set_process(true)
		p.set_physics_process(true)
