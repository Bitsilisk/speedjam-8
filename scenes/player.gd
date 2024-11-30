extends CharacterBody2D

const SLAM_SENSITIVITY:float = 10
const TOP_SPEED:float = 300
const SPEED:float = .25
const JUMP_SPEED:float = 300
const WALL_DISTANCE:int = 16
const COYOTE_LENGTH:float = .1

@export var flow_speed_increase_by = 3
@export var flow_speed_dropoff = 1

@onready var camera = $PhantomCamera2D
@onready var forward_raycast:RayCast2D = $RayCast2D
@onready var player_ui = $player_ui
@onready var heart_particales = $GPUParticles2D

# Flow, increases top speed
var flow:float = 0
@onready var sfx_jump: AudioStreamPlayer = $sfx_jump
@onready var sfx_wallkick: AudioStreamPlayer = $sfx_wallkick
@onready var sfx_land: AudioStreamPlayer = $sfx_land

var flow_bar
var flow_release: bool

var last_velocity:Vector2
var coyote_time:float = 0
var stunned:bool

func is_on_coyote_floor(delta:float) -> bool:
	if is_on_floor():
		coyote_time = 0
		return true
	coyote_time += delta
	return coyote_time < COYOTE_LENGTH

func _physics_process(delta):
	rotate_raycast()
	add_flow_progress()
	release_flow()
	check_stun()
	apply_gravity(delta)
	handle_input(delta)
	camera.follow_offset = velocity * Vector2(.8,.5)
	if not is_zero_approx(velocity.x):
		last_velocity = velocity
	move_and_slide()

func handle_input(delta:float):
	var jump_input:bool = Input.is_action_just_pressed("jump")
	if is_on_coyote_floor(delta):
		if jump_input:
			jump()
			sfx_jump.play()
		else:
			var new_direction = get_input_direction()
			var new_velocity:float = new_direction * SPEED * delta * 1000.
			if abs(velocity.x + new_velocity) < TOP_SPEED + flow:
				if new_direction != sign(last_velocity.x):
					new_velocity *= 2
				velocity.x += new_velocity
	else:
		if jump_input and forward_raycast.is_colliding():
			velocity.x = TOP_SPEED * -sign(last_velocity.x)
			jump()
			sfx_wallkick.play()

func apply_gravity(delta:float):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func check_stun():
	var movement_direction:int = sign(velocity.x)
	if movement_direction == 0:
		if abs(last_velocity.x) >= TOP_SPEED-SLAM_SENSITIVITY and is_on_floor():
			stunned = true
	else:
		stunned = false
	
func jump():
	stunned = false
	velocity.y = -JUMP_SPEED
	coyote_time = 10
	
func get_input_direction() -> int:
	return sign(Input.get_axis("move_left", "move_right"))

func rotate_raycast():
	forward_raycast.target_position.x = WALL_DISTANCE * sign(last_velocity.x)

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
		flow += flow_speed_increase_by
	else:
		flow = max(0, flow-flow_speed_dropoff)
		heart_particales.emitting = false
