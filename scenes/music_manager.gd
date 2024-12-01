extends Node

func play(track:String):
	var target:AudioStreamPlayer = find_child(track)
	var children = get_children()
	if is_instance_valid(target):
		printerr("Invalid track to play: {0}\nCurrent tracks: {1}".format([track, get_children()]))
		return
		
	for child:AudioStreamPlayer in get_children():
		if child != target and child.playing:
			var tween:Tween = create_fade_tween(child, 0, db_to_linear(child.volume_db))
			tween.finished.connect(func():
				child.stop()
			)
	
	target.volume_db = linear_to_db(0)
	target.play()
	var tween:Tween = create_fade_tween(target, 1)
	
func create_fade_tween(track_node:AudioStreamPlayer, volume:float, duration:float=1.0) -> Tween:
	var tween:Tween = create_tween()
	tween.tween_property(track_node, "volume_db", volume, .5)
	return tween
