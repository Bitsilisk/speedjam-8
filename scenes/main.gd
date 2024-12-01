extends Control

@export var levels:Array[PackedScene]
@export var game_node:Node2D
@export var main_menu:Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_main_menu():
	unload_all()
	main_menu.show()

func load_level(index:int) -> void:
	if levels.size() == index:
		printerr("Invalid level index: {0}".format(index))
		return
		
	if not is_instance_valid(game_node):
		return
	
	var current_level = game_node.get_child(0)
	var level = levels[index].instantiate()
	#level.next_level = 
	
	if is_instance_valid(current_level):
		current_level.tree_exited.connect(func():
			_add_level(level)
		)
		remove_child(current_level)
	else:
		_add_level(level)
	
func _add_level(level:Node2D):
	game_node.add_child(level)
	main_menu.hide()
	
func unload_all(replace_with:int = -1) -> void:
	for child in game_node.get_children():
		child.queue_free()
