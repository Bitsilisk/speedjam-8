extends Control

@export var label:Label

@onready var main = get_node("/root/Main")

var player_manager:PlayerManager

func _on_visibility_changed():
	if is_instance_valid(player_manager) and visible:
		var best_score:bool = main.register_score(player_manager.time)
		if best_score:
			label.text = "New personal record!"
		else:
			label.text = "Old record: {0}".format([main.current_record])
	$IcyWin.play()
	var tree:SceneTree = get_tree()
	if not is_instance_valid(tree):
		return
	tree.paused = visible


func _on_again_pressed():
	hide()
	player_manager._reset()


func _on_next_level_pressed():
	hide()
	main.next_level()
