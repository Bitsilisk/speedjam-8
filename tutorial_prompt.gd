extends Area2D
@export_multiline var text:String
@onready var label:Label = $CanvasLayer/MarginContainer/Label


func _ready():
	label.text = text

func _on_body_entered(body):
	if not body is Player:
		return
	var tween = create_tween()
	tween.tween_property(label, "self_modulate", Color.WHITE, .2)

func _on_body_exited(body):
	if not body is Player:
		return
	var tween = create_tween()
	tween.tween_property(label, "self_modulate", Color.TRANSPARENT, .2)
	
