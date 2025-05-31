tool
extends Node

@export var player_path: NodePath
@export var sprite_path: NodePath
@export var animation_player_path: NodePath
@export var recording_interval := 0.1  # seconds

var recording := false
var frames := []
var animation_length := 0.0
var timer := null

func _ready():
	if Engine.is_editor_hint():
		return
	timer = Timer.new()
	timer.wait_time = recording_interval
	timer.one_shot = false
	timer.timeout.connect(_record_frame)
	add_child(timer)

func start_recording():
	frames.clear()
	animation_length = 0.0
	recording = true
	timer.start()

func stop_recording():
	recording = false
	timer.stop()
	bake_animation()

func _record_frame():
	if not recording:
		return
	var player = get_node(player_path)
	var sprite = get_node(sprite_path)
	frames.append({
		"time": animation_length,
		"position": player.position,
		"animation": sprite.animation,
		"flip_h": sprite.flip_h
	})
	animation_length += recording_interval

func bake_animation():
	var anim_player = get_node(animation_player_path)
	var animation = Animation.new()
	animation.length = animation_length

	var position_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(position_track, get_node(player_path).get_path().to_subpath("position"))

	var flip_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(flip_track, get_node(sprite_path).get_path().to_subpath("flip_h"))

	var anim_track = animation.add_track(Animation.TYPE_METHOD)
	animation.track_set_path(anim_track, get_node(sprite_path).get_path())

	for frame in frames:
		animation.track_insert_key(position_track, frame["time"], frame["position"])
		animation.track_insert_key(flip_track, frame["time"], frame["flip_h"])
		animation.track_insert_key(anim_track, frame["time"], { "method": "play", "args": [frame["animation"]] })

	anim_player.add_animation("baked_cutscene", animation)
	anim_player.play("baked_cutscene")
