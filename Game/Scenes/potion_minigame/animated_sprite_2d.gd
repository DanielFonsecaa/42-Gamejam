extends AnimatedSprite2D

func _ready() -> void:
	play("default")
	$AudioStreamPlayer2D.play()
