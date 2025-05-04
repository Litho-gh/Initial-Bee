extends Control

@onready var speed_label: Label = $Speed
@onready var lap_label: Label = $Lap

@export var needle: Sprite2D
@export var max_speed: float = 140.0

const MIN_ANGLE = -300.0
const MAX_ANGLE = -65.0

func _ready():
	needle.rotation_degrees = 0.0

func update_speed_and_lap(speed: float, lap: int, total_laps: int):
	lap_label.text = "Lap: " + str(lap + 1) + "/" + str(total_laps)
	
	update_speedometer(speed)

func update_speedometer(speed: float):
	if needle: 
		var clamped_speed = clamp(speed, 0.0, max_speed)
		
		var rotation_range = MAX_ANGLE - MIN_ANGLE
		var speed_ratio = clamped_speed / max_speed
		speed_ratio = clamp(speed_ratio, 0.0, 1.0)
		var target_angle = MIN_ANGLE + (rotation_range * speed_ratio)
		
		needle.rotation_degrees = lerp(needle.rotation_degrees, target_angle, 0.2)
