extends Node2D
class_name PlayerManager

@export var PlayerScene:PackedScene
@export var phantom_camera:PhantomCamera2D
@export var camera:Camera2D
@export var pause_menu:Control
@export var player_hud:Control
var time:float = 0.
var player:Player
# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_player()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		_reset()
	if Input.is_action_just_pressed("escape"):
		pause_menu.show()
	time += delta

func _spawn_player():
	player = PlayerScene.instantiate()
	player.camera = phantom_camera
	add_child(player)
	phantom_camera.follow_target = player
	camera.enabled = true
	time = 0

func _reset():
	player.queue_free()
	_spawn_player()
