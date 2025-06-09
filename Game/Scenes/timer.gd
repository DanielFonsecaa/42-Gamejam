extends Node2D

var frame_count := 0
var seconds_passed := 0
@onready var night_overlay := $NightOverlay
const CYCLE_DURATION = 300
const NIGHT_START = 225
const NIGHT_END = 75
@onready var time_label = $"../Day-money/Label3"

func _ready():
	$Timer.start()

func _process(delta):
	frame_count += 1
	
	if frame_count % 60 == 0:
		seconds_passed += 1
		print(seconds_passed)
	#	if seconds_passed % 2 == 1:
	#		print("Tick")
	#	else:
	#		print("Tock")
		var time_left = CYCLE_DURATION - seconds_passed
		var minutes = time_left / 60
		var seconds = time_left % 60
		time_label.text = "Time: %02d:%02d" % [minutes, seconds]
	if seconds_passed == 300:
		Properties.day += 1
		seconds_passed = 0
		print("New day! Day:", Properties.day)

func _update_day_night():
	var time_of_day = seconds_passed % CYCLE_DURATION
	
	if time_of_day >= NIGHT_START or time_of_day < NIGHT_END:
		night_overlay.color.a = 0.5
	else:
		night_overlay.color.a = 0.0
