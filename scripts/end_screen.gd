extends Control

@onready var main = get_node("/root/Main")
@export var label:Label

func _on_visibility_changed():
	var tree:SceneTree = get_tree()
	if not is_instance_valid(tree):
		return
	tree.paused = visible
	if not visible or not is_instance_valid(main):
		return
	%MusicManager.play("Win")
	if main.has_completed_all():
		var total_time = main.get_total_time()
		label.text = "The End!\n\nTotal Time\n{0}\n\nThanks for playing!".format([
			main.time_to_string(total_time)
		])
	else:
		label.text = "The End!\n\nComplete all levels for a total time!\n\nThanks for playing!"


func _on_button_pressed():
	hide()
	main.show_main_menu()
