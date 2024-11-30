extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if get_tree().current_scene.has_method("level_finish"):
			get_tree().current_scene.level_finish()
