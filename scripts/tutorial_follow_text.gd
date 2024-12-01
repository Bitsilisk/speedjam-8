extends Control

@onready var area_2d: Area2D = $Area2D
@onready var player = $"../../CharacterBody2D"
var text: Label

func _ready() -> void:
	for i in get_children():
		if i.is_class('Label'):
			text = i
			break

func _process(delta: float) -> void:
	#if area_2d.has_overlapping_bodies():
	if area_2d.get_overlapping_bodies().has( player):
		text.global_position = player.global_position + Vector2(-50, -80)
		
