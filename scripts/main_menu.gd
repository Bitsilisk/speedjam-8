extends Control
@export var level_choices:Control
@export var credits:Control
@export var leaderboard:Control
@export var game_node:Node2D
var current_level
@onready var leaderboard_logic = $leaderboard_container/MarginContainer/leaderboard
var levels_played := []
var total_time_all_levels: int
var curr_level_time: int

@onready var main = get_node("/root/Main")
@onready var icy_title: AudioStreamPlayer = $"Icy Title"
@onready var between_levels_screen = $between_levels
@onready var level_time = $between_levels/MarginContainer/HBoxContainer/level_time
@onready var end_screen = $end_screen
@onready var total_time_text = $end_screen/CenterContainer/VBoxContainer/total_time

func _on_start_pressed() -> void:
	main.load_level(0)

func _on_choose_level_toggled(toggled_on: bool) -> void:
	credits.visible = false
	level_choices.visible = toggled_on

func _on_leaderboard_pressed() -> void:
	leaderboard.show()

func _on_close_pressed() -> void:
	leaderboard.hide()

func _on_credits_toggled(toggled_on: bool) -> void:
	level_choices.visible = false
	credits.visible = toggled_on
	
func _on_submit_time_pressed() -> void:
	leaderboard_logic.load_new_info(total_time_all_levels)
	end_screen.hide()
	leaderboard_logic.update_info()
	leaderboard.show()


func reset_buttons():
	if not is_instance_valid(main):
		return
	for child in level_choices.get_children():
		child.queue_free()
	
	for level in range(main.levels.size()):
		var button = Button.new()
		button.text = "Level {0}".format([level+1])
		if main.scores[level] != -1:
			button.text += "\n{0}:{1}".format([
			"%d" % floor(main.scores[level]/60.0),
			"%2.2f" % fmod(main.scores[level],60)
		])
		button.pressed.connect(func():
			main.load_level(level)
		)
		level_choices.add_child(button)

func _on_visibility_changed():
	if visible:
		%MusicManager.play('Title')
	else:
		%MusicManager.play('Level')
