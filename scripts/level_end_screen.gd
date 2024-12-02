extends Control

@export var time_label:Label

@onready var main = get_node("/root/Main")

var player_manager:PlayerManager

func _on_visibility_changed():
	if is_instance_valid(player_manager):
		time_label.text = "Level Time: {0}".format([player_manager.time])
	
	var tree:SceneTree = get_tree()
	if not is_instance_valid(tree):
		return
	tree.paused = visible


func _on_again_pressed():
	player_manager._reset()
	hide()


func _on_next_level_pressed():
	main.next_level()
	hide()
