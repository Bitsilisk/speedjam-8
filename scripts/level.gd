extends Node2D

var next_level:int


func _on_flag_body_entered(body):
	if body is Player:
		print("player hit flag!")
