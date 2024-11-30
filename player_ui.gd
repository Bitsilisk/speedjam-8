extends CanvasLayer

var total_time := 0

@onready var timer = $Timer
@onready var time_display = $hud/MarginContainer/timer/VBoxContainer/time
@onready var combo_container = $hud/MarginContainer/combo_container
@onready var flow_bar: ProgressBar = $hud/MarginContainer/MarginContainer/ProgressBar

func _ready():
	timer.start()


func _on_timer_timeout() -> void:
	total_time += 1
	var min = int(total_time / 60)
	var sec = total_time - min * 60
	time_display.text = '%02d:%02d' % [min,sec]

func report_discard_time():
	var current = total_time
	total_time = 0
	return current
