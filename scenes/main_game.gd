extends Control

@onready var main2d: Node2D = $main_2d
@onready var main_menu = $main_menu
@onready var leaderboard = $main_menu/HBoxContainer/leaderboard

var levels: Array = ["res://scenes/testbed.tscn", "res://scenes/testbed_2.tscn"]
var level_instance: Node2D
var level_idx: int = 0
var total_time := 0
var allowed_to_restart = false
#level_name
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("restart") && allowed_to_restart:
		get_tree().paused = false
		load_level(level_idx)

func load_level(idx: int):
	unload_level()
	main_menu.hide()
	var level_r = load(levels[idx])
	
	if level_r:
	#	level_instance = level_r.instance()
		level_instance = level_r.instantiate()
		level_idx = idx
		main2d.add_child(level_instance)
	
func unload_level():
	if is_instance_valid(level_instance):
		level_instance.queue_free()
		#get_tree().root.get_node("PhantomCameraManager").queue_free()
		level_instance = null
		#level_idx = ""

func level_finish():
	total_time += get_tree().get_first_node_in_group("player_ui"
	).report_discard_time()
	print('total_time ', total_time)
	print('next level')
	if levels.size() == (level_idx + 1):
		leaderboard.load_new_info(total_time)
		
		# show smth
	else:
		load_level(level_idx + 1)


func _on_start_pressed() -> void:
	allowed_to_restart = true
	load_level(0)
