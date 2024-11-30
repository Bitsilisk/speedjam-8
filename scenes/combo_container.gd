extends MarginContainer


@onready var arrow_up = $HBoxContainer/arrow_up
@onready var arrow_left = $HBoxContainer/arrow_left
@onready var arrow_right = $HBoxContainer/arrow_right
@onready var arrow_down = $HBoxContainer/arrow_down


@onready var combo_hbox = $HBoxContainer
var additional := []

func show_with(combo_arr: Array):
	show()
	for i in combo_arr:
		var arrow: TextureRect#= default_up_arrow.duplicate()
		#arrow.show()
		match i:
			'up':
				arrow = arrow_up.duplicate()
			'down':
				arrow = arrow_down.duplicate()
			'left':
				arrow = arrow_left.duplicate()
			'right':
				arrow = arrow_right.duplicate()
		additional.append(arrow)
		arrow.show()	
		combo_hbox.add_child(arrow)
func wipe():
	for i in additional:
		i.queue_free()
	additional.clear()
	hide()
