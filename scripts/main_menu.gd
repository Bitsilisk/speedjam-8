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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for level in range(main.levels.size()):
		var button = Button.new()
		button.text = "Level {0}".format([level+1])
		button.pressed.connect(func():
			main.load_level(level)
		)
		level_choices.add_child(button)


func _on_start_pressed() -> void:
	main.load_level(0)

func _on_choose_level_toggled(toggled_on: bool) -> void:
	credits.visible = false
	level_choices.visible = toggled_on

func reload_level():
	main.load_level(current_level)

func load_next_level():
	pass
	#show()
	#$CenterContainer.hide()
	#curr_level_time = get_tree().get_first_node_in_group("player_ui"
				#).report_discard_time()		
#
	#if levels.size() == (current_level + 1):
		#levels_played.append(current_level)
#
	#if levels.size() == (current_level + 1) && played_all_levels():
		#total_time_all_levels += curr_level_time
		#main.unload_all()
		#total_time_text.text = "Your total time: " + str(total_time_all_levels)
		#end_screen.show()
	#else:
		#main.unload_all()
		#level_time.text = str(total_time_all_levels) + " Level Time: " + str(int(curr_level_time))
		#between_levels_screen.show()

func _on_leaderboard_pressed() -> void:
	leaderboard.show()

func _on_close_pressed() -> void:
	leaderboard.hide()

func _on_credits_toggled(toggled_on: bool) -> void:
	level_choices.visible = false
	credits.visible = toggled_on

func played_all_levels():
	pass
	#return levels_played.size() == levels.size()

func _on_again_pressed() -> void:
	reload_level()
	
func _on_next_level_pressed() -> void:
	between_levels_screen.hide()
	levels_played.append(current_level)
	total_time_all_levels += curr_level_time
	curr_level_time = 0
	main.load_level(current_level + 1)

func _on_submit_time_pressed() -> void:
	leaderboard_logic.load_new_info(total_time_all_levels)
	end_screen.hide()
	leaderboard_logic.update_info()
	leaderboard.show()
	
	


func _on_visibility_changed():
	if visible:
		%MusicManager.play('Title')
	else:
		%MusicManager.play('Level')
