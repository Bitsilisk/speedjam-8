extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if get_tree().current_scene.has_method("level_finish"):
		get_tree().current_scene.level_finish()
