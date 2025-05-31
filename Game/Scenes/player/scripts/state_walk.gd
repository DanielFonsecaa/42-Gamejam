class_name State_Walk extends State

@export var move_speed : float = 100.0

@onready var idle: State_Idle = $"../Idle"

func Enter() -> void:
	player.UpdateAnimation("walk")

func Exit() -> void:
	pass
	
func Process( _delta : float) -> State:
	if player.direction == Vector2.ZERO:
		return idle

	player.velocity = player.direction * move_speed

	if player.SetDirection():
		player.UpdateAnimation("walk")

	return null

func Physics( _delta : float) -> State:
	return null

func HandleInput( _event: InputEvent ) -> State:
	return null
