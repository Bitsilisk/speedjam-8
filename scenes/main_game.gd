extends Control

@onready var main2d: Node2D = $main_2d
@onready var main_menu = $main_menu
@onready var leaderboard = $main_menu/HBoxContainer/leaderboard

var level_instance: Node2D
var level_name: String
var total_time := 0

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().paused = false
		load_level(level_name)

func load_level(level_name_s):
	unload_level()
	main_menu.hide()
	var level_r = load(level_name_s)
	
	if level_r:
	#	level_instance = level_r.instance()
		level_instance = level_r.instantiate()
		level_name = level_name_s
		main2d.add_child(level_instance)
	
func unload_level():
	if is_instance_valid(level_instance):
		level_instance.queue_free()
		level_instance = null
		level_name = ""

func level_finish():
	total_time += get_tree().get_first_node_in_group("player_ui"
	).report_discard_time()
	print('total_time ', total_time)
	print('next level')
	unload_level()
	leaderboard.load_new_info(total_time)
	main_menu.show()
	#record the time for the current level
	#if level_last?
	#show player the time and ask if he wants to upload it	


func _on_start_pressed() -> void:
	load_level("res://scenes/testbed.tscn")
