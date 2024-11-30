extends CharacterBody2D
@export var speed:float
@export var top_speed:float = 10
@export var jump_speed:float = 500
@export var wall_distance:int = 16
@export var coyote_amount = .5
@export var flow_speed_increase_by = 3
@export var flow_speed_dropoff = 1

@onready var camera = $PhantomCamera2D
@onready var forward_raycast:RayCast2D = $RayCast2D

@onready var player_ui = $player_ui
@onready var heart_particales = $GPUParticles2D
@onready var sfx_jump: AudioStreamPlayer = $sfx_jump
@onready var sfx_wallkick: AudioStreamPlayer = $sfx_wallkick
@onready var sfx_land: AudioStreamPlayer = $sfx_land

var flow_bar
var flow_release: bool

var last_direction:int = 0
var coyote_time:float = 0

func floor_check(delta:float):
	if is_on_floor():
		coyote_time = 0
		return true
	coyote_time += delta
	return coyote_time < coyote_amount
	

func _physics_process(delta):
	rotate_raycast()
	add_flow_progress()
	release_flow()
	
	var jump_input:bool = Input.is_action_just_pressed("jump")
	var movement_direction:int = sign(velocity.x)
	if movement_direction != 0:
		last_direction = movement_direction

	var on_floor:bool = floor_check(delta)
#	This looks weird, but we don't want coyote time affecting actual gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if not on_floor:
		if jump_input and forward_raycast.is_colliding():
			velocity.x = top_speed * -last_direction
			velocity.y = -jump_speed
			coyote_time = 10
			sfx_wallkick.play()
	elif jump_input:
		velocity.y = -jump_speed
		coyote_time = 10
		sfx_jump.play()
	else:
		var new_direction = get_direction()
		var new_velocity:float = velocity.x + new_direction * speed * delta * 1000.
		if abs(new_velocity) < top_speed:
			if new_direction != sign(last_direction):
				new_velocity = velocity.x + new_direction * speed * delta * 1000. * 2
			velocity.x = new_velocity
	
	if forward_raycast.is_colliding():
		var collider = forward_raycast.get_collider()
		
	camera.follow_offset = velocity * Vector2(.8,.2)
	move_and_slide()

func get_direction() -> int:
	return sign(Input.get_axis("move_left", "move_right"))

func rotate_raycast():
	forward_raycast.target_position.x = wall_distance * last_direction

func add_flow_progress():
	#if going at top speed on the floor
	if velocity.length() > 295 && is_on_floor() && !flow_release:
		player_ui.flow_bar.value += 1	
		
	# if close to edge and pressed jump 
	 #flow + 10

func release_flow():
	flow_release = Input.is_action_pressed("flow_release")
	
	if flow_release && player_ui.flow_bar.value > 0.5 && !is_on_floor():
		heart_particales.emitting = true
		player_ui.flow_bar.value -= 0.5
		top_speed += flow_speed_increase_by
	else:
		top_speed -= flow_speed_dropoff
		top_speed = clamp(top_speed, 300, 500)
		heart_particales.emitting = false
