extends Node
# Developer feature mostly, but I guess we could make a ui element for it later.
@export var disabled:bool = false

func _ready():
	if not disabled:
		return
	for child:AudioStreamPlayer in get_children():
		child.stop()
	
func play(track:String):
	if disabled:
		return
	var target:AudioStreamPlayer = find_child(track)
	var children = get_children()
	if not is_instance_valid(target):
		printerr("Invalid track to play: {0}\nCurrent tracks: {1}".format([track, children]))
		return
		
	for child:AudioStreamPlayer in get_children():
		if child != target and child.playing:
			var tween:Tween = create_fade_tween(child, 0, db_to_linear(child.volume_db))
			tween.finished.connect(func():
				child.stop()
			)
	
	target.volume_db = linear_to_db(1)
	target.play()
	
func create_fade_tween(track_node:AudioStreamPlayer, volume:float, duration:float=.1) -> Tween:
	var tween:Tween = create_tween()
	tween.tween_property(track_node, "volume_db", volume, duration)
	return tween
