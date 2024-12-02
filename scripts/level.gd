extends Node2D
class_name Level

var next_level:int
var flag:Area2D:
	get:
		return find_child("Flag")

var player_manager:PlayerManager:
	get:
		return find_child("PlayerManager")
