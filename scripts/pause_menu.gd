extends Control
@onready var main = get_node("/root/Main")
@onready var sfx_uiclick: AudioStreamPlayer = $sfx_uiclick

func _on_visibility_changed():
	var tree:SceneTree = get_tree()
	if not is_instance_valid(tree):
		return
	tree.paused = visible

	
func _on_resume_pressed():
	sfx_uiclick.play()
	print("RESUME?")
	hide()

func _on_exit_pressed():
	sfx_uiclick.play()
	print("EXIT?")
	hide()
	main.show_main_menu()
