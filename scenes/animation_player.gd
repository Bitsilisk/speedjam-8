extends AnimationPlayer

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
		play("fall_right")
		fell_down = true

		return
	fell_down = false

	if !player.is_on_floor() && player.flow_release:
		play('spin')
	elif !player.is_on_floor():
		play('air')
	elif dir == 0:
		play("idle")
	elif dir == 1:
		#flip_h = false
		play("left")
	elif dir == -1:
		#flip_h = true
		play("right")
