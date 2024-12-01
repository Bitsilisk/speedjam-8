extends Control

@export var levels:Array[PackedScene]
@export var level_choices:Control
@onready var credits: Control = $CenterContainer/HBoxContainer/credits
@export var game_node:Node2D
@onready var leaderboard = $leaderboard
var current_level

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
	if levels.size() == index:
		printerr("Invalid level index: {0}".format(index))
		return
		
	if not is_instance_valid(game_node):
		return
	
	for child in game_node.get_children():
		child.queue_free()
	
	var level = levels[index].instantiate()
	current_level = index
	game_node.add_child(level)
	hide()

func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	load_level(0)


func _on_choose_level_toggled(toggled_on: bool) -> void:
	credits.visible = false
	level_choices.visible = toggled_on

func reload_level():
	for child in game_node.get_children():
		child.call_deferred('free')
	await get_tree().create_timer(0.01).timeout 
	var level = levels[current_level].instantiate()
	game_node.add_child(level)

func load_next_level():
	#if levels.size() == index:
		#upload it
	#else:	
	load_level(current_level + 1)

func _on_leaderboard_pressed() -> void:
	leaderboard.show()

func _on_close_pressed() -> void:
	leaderboard.hide()

func _on_credits_toggled(toggled_on: bool) -> void:
	level_choices.visible = false
	credits.visible = toggled_on
