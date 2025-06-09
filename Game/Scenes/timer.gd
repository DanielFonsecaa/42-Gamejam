extends Node2D

var frame_count := 0
var seconds_passed := 0
var break_seconds_passed := 0
var in_break := false
@onready var night_overlay := $NightOverlay
const BREAK_DURATION = 120
const CYCLE_DURATION = 5
#set to 5 for testing, normal is 300
const NIGHT_START = 225
const NIGHT_END = 75
@onready var time_label = $"../Day-money/Label3"
@onready var door = $"../Door"
@onready var door_collision = $"../Door/StaticBody2D/CollisionShape2D"

func _ready():
	$Timer.start()

func _process(delta):
	frame_count += 1
	
	if frame_count % 60 == 0:
		if in_break:
			break_cycle()
		else:
			day_cycle()
			
func day_cycle():
	seconds_passed += 1
	var time_left = CYCLE_DURATION - seconds_passed
	var minutes = time_left / 60
	var seconds = time_left % 60
	time_label.text = "Time: %02d:%02d" % [minutes, seconds]

	if seconds_passed == CYCLE_DURATION:
		Properties.day += 1
		print(seconds_passed)
		seconds_passed = 0
		in_break = true
		door.visible = false
		door_collision.disabled = true
		break_seconds_passed = 0
		time_label.text = "Break: 02:00"
		print("New day! Day:", Properties.day)

func break_cycle():
	break_seconds_passed += 1
	var time_left = BREAK_DURATION - break_seconds_passed
	var minutes = time_left / 60
	var seconds = time_left % 60
	time_label.text = "Break: %02d:%02d" % [minutes, seconds]

	if break_seconds_passed >= BREAK_DURATION:
		in_break = false
		print(break_seconds_passed)
		break_seconds_passed = 0
		seconds_passed = 0
		door.visible = true
		door_collision.disabled = false
		time_label.text = "Time: 05:00"
		
		print("Break over. Starting new day...")

func _update_day_night():
	var time_of_day = seconds_passed % CYCLE_DURATION
	
	if time_of_day >= NIGHT_START or time_of_day < NIGHT_END:
		night_overlay.color.a = 0.5
	else:
		night_overlay.color.a = 0.0
