extends Control

var bg_music := AudioStreamPlayer.new()

var main_menu = SceneManager.load_scene("res://MainMenu/MainMenu.tscn")

func _ready():
	visible = false
	bg_music.stream = load("res://Sounds/Pause_music.wav")
	bg_music.autoplay = true
	bg_music.volume_db = -20
	add_child(bg_music)
	$VBoxContainer/ResumeButton.text = "Resume"
	$VBoxContainer/QuitButton.text = "Quit to Menu"
	$VBoxContainer/RestartButton.text = "Restart"

	$VBoxContainer/ResumeButton.pressed.connect(_on_resume_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)
	$VBoxContainer/RestartButton.pressed.connect(_on_restart_pressed)
	

func toggle_pause():
	visible = not visible
	get_tree().paused = visible

	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resume_pressed():
	toggle_pause()

func _on_quit_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	SceneManager.switch_scene(main_menu)

func _on_restart_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var current_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(current_scene_path)
