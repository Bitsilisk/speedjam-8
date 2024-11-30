extends AnimatedSprite2D

@onready var player = $".."
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	update_animation()

var fell_down := false
func update_animation():
	var dir = sign(Input.get_axis("move_left", "move_right"))
	if fell_down && dir == 0:
		play("crying")
		return
			
	if player.is_on_floor() && player.forward_raycast.is_colliding():
		play("falling")
		fell_down = true
		#animation_player.flip_h = false
		return
	fell_down = false

	if !player.is_on_floor() && player.flow_release:
		play('spin')
	elif dir == 0:
		play("idle")
	elif dir == 1:
		flip_h = false
		play("skating")
	elif dir == -1:
		flip_h = true
		play("skating")
