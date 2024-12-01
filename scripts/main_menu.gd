extends Control

@export var levels:Array[PackedScene]
@export var level_choices:Control
@export var game_node:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for level in range(levels.size()):
		var button = Button.new()
		button.text = "Level {0}".format([level+1])
		button.pressed.connect(func():
			load_level(level)
		)
		level_choices.add_child(button)


func load_level(index:int) -> void:
	if levels.size() < index:
		printerr("Invalid level index: {0}".format(index))
		return
		
	if not is_instance_valid(game_node):
		return
	
	for child in game_node.get_children():
		child.queue_free()
	
	var level = levels[index].instantiate()
	game_node.add_child(level)
	hide()

func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	load_level(0)


func _on_choose_level_toggled(toggled_on: bool) -> void:
	level_choices.visible = toggled_on


func _on_credits_pressed() -> void:
	pass # Replace with function body.
