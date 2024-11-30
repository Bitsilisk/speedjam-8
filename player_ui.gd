extends CanvasLayer
# I think we can handle this by just adding delta on _process.
var total_time:float = 0

@onready var timer = $Timer
@onready var time_display = $hud/MarginContainer/timer/VBoxContainer/time
@onready var combo_container = $hud/MarginContainer/combo_container
@onready var flow_bar: ProgressBar = $hud/MarginContainer/MarginContainer/ProgressBar

func _ready():
	timer.start()

func _process(_delta) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().paused = false
		if get_tree().current_scene.has_method('reload_level'):
			get_tree().current_scene.reload_level()
		else:
			get_tree().reload_current_scene()
		
func _on_timer_timeout() -> void:
	total_time += 1
	var minute = floor(total_time / 60.0)
	var second = total_time - minute * 60
	time_display.text = '%02d:%02d' % [minute,second]

func report_discard_time():
	var current = total_time
	total_time = 0
	return current
