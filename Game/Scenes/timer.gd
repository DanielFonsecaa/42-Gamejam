extends Node2D

var frame_count := 0
var seconds_passed := 0
onready var night_overlay := $NightOverlay

const CYCLE_DURATION = 300
const NIGHT_START = 225
const NIGHT_END = 75

func _ready():
	$Timer.start()

func _process(delta):
	frame_count += 1
	
	if frame_count % 60 == 0:
		seconds_passed += 1
		if seconds_passed % 2 == 1:
			print("Tick")
		else:
			print("Tock")
	if frame_count == 18000:
		print("5 minutes have passed!")

func _update_day_night():
	var time_of_day = seconds_passed % CYCLE_DURATION
	
	if time_of_day >= NIGHT_START or time_of_day < NIGHT_END:
		night_overlay.color.a = 0.5
	else:
		night_overlay.color.a = 0.0
