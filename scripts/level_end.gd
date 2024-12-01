extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var level_loader = get_tree().get_first_node_in_group("level_loader")
		if level_loader:
			level_loader.load_next_level()
