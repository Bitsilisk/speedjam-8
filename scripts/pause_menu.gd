extends MarginContainer


var paused := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()

func _process(_delta:float) -> void:
	if Input.is_action_just_pressed("escape"):
		pause_menu()

func _on_resume_pressed() -> void:
	pause_menu()


func _on_controls_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	pause_menu()
	get_tree().reload_current_scene()

func pause_menu():
	paused = !paused
	get_tree().paused = paused
	self.visible = paused
	#self.show()
