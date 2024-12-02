extends Control

@export var levels:Array[PackedScene]
@export var game_node:Node2D
@export var main_menu:Control
@export var level_end_screen:Control

var current_level_index:int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_main_menu():
	unload_all()
	main_menu.show()

func load_level(index:int) -> bool:
	if levels.size() == index:
		printerr("Invalid level index: {0}".format(index))
		return false
		
	if not is_instance_valid(game_node):
		return false
	
	var level = ready_level(levels[index])
	level.flag
	
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
	
func unload_all(replace_with:int = -1) -> void:
	for child in game_node.get_children():
		child.queue_free()

func next_level():
	var valid_level:bool = load_level(current_level_index + 1)
	print("loading next level: {0}".format([valid_level]))
