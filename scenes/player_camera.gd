extends PhantomCamera2D
func _physics_process(delta):
	if not _follow_target_physics_based or _is_active: return
	print("Called!")
	process_logic(delta)
