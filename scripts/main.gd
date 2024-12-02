extends Control

@export var levels:Array[PackedScene]
@export var game_node:Node2D
@export var main_menu:Control
@export var level_end_screen:Control
@export var end_screen:Control

var scores:Array[float]
var current_level_index:int = -1

var current_record:String:
	get:
		print("Getting score for {0}".format([current_level_index]))
		return "{0}:{1}".format([
			"%d" % floor(scores[current_level_index]/60.0),
			"%2.2f" % fmod(scores[current_level_index],60)
		])
		
func _ready():
	for level_index in range(levels.size()):
		scores.append(-1)
	show_main_menu()

func show_main_menu():
	unload_all()
	main_menu.show()
	main_menu.reset_buttons()

func load_level(index:int) -> bool:
	if levels.size() == index:
		printerr("Invalid level index: {0}".format(index))
		return false
		
	if not is_instance_valid(game_node):
		return false
	
	var level = ready_level(levels[index])
	
	var current_level = game_node.get_child(0)
	if is_instance_valid(current_level):
		current_level.tree_exited.connect(func():
			_add_level(level)
			current_level.queue_free()
		)
		game_node.remove_child(current_level)
	else:
		_add_level(level)
		
	current_level_index = index
	return true
		
func ready_level(level_scene:PackedScene) -> Level:
	var level:Level = level_scene.instantiate()
	level.flag.body_entered.connect(func(body):
		if body is Player:
			level_end_screen.show()
	)
	level_end_screen.player_manager = level.player_manager
	return level
	
func _add_level(level:Node2D):
	game_node.add_child(level)
	main_menu.hide()
	
func unload_all() -> void:
	for child in game_node.get_children():
		child.queue_free()

func register_score(score:float) -> bool:
	if scores[current_level_index] > score or scores[current_level_index] < 0:
		print("setting score for {0} to {1}".format([current_level_index, score]))
		scores[current_level_index] = score
		return true
	return false

func next_level():
	var valid_level:bool = load_level(current_level_index + 1)
	if valid_level:
		return
	else:
		end_screen.show()

func has_completed_all():
	for score in scores:
		if score == -1:
			return false
	return true
	
func get_total_time()->float:
	var total:float = 0
	for score in scores:
		total += score
	return total

func time_to_string(time:float) -> String:
	return "{0}:{1}".format([
		"%d" % floor(time/60.0),
		"%2.2f" % fmod(time,60)
	])
