extends Control

@export var player_manager:PlayerManager
@export var time_label:Label
@export var flow_bar:ProgressBar
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_instance_valid(player_manager) or not is_instance_valid(player_manager.player):
		return
	
	time_label.text = "Time {0}:{1}".format([
		"%d" % floor(player_manager.time/60.0),
		"%2.2f" % fmod(player_manager.time,60)
	])
	flow_bar.value = player_manager.player.flow_amount
