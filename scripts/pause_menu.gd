extends Control
@onready var main = get_node("/root/Main")

func _on_visibility_changed():
	var tree:SceneTree = get_tree()
	if not is_instance_valid(tree):
		return
	tree.paused = visible

	
func _on_resume_pressed():
	print("RESUME?")
	hide()

func _on_exit_pressed():
	print("EXIT?")
	hide()
	main.show_main_menu()
