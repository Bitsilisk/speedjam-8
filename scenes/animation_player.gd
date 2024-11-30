extends AnimationPlayer

@onready var player = get_parent()
@onready var sprite = $"../Sprite2D"
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(_delta: float) -> void:
	update_animation()

func update_animation():
	var movement_direction = sign(player.velocity.x)
	var input_direction = player.get_input_direction()
	if player.is_on_floor():
		if input_direction != 0:
			sprite.flip_h = input_direction < 0
	else:
		if movement_direction != 0:
			sprite.flip_h = movement_direction < 0

	if not player.is_on_floor() && player.using_flow:
		play('spin')
	elif player.stunned:
		if is_playing():
			play("fall_right")
	elif player.on_wall:
		play("wall_hang_right")
	elif not player.is_on_floor():
		if player.velocity.y > 0:
			play("jump_right")
		else:
			play('pose_right')
	elif input_direction == 0:
		play("idle")
	elif input_direction != 0:
		if player.is_flow_speed():
			play("spin")
		else:
			play("left")

#func 
