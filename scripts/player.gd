extends CharacterBody2D

const SLAM_SENSITIVITY:float = 10
const TOP_SPEED:float = 200
const TOP_FLOW_SPEED:float = 400
const SPEED:float = .2
const JUMP_SPEED:float = 300
const DASH_SPEED:float = 500
const WALL_DISTANCE:int = 16
const COYOTE_LENGTH:float = .1
const FLOW_SPEED_PERCENT:float = .9
const FLOW_BUILD_RATE = 10
const FLOW_DECAY_RATE = 1

@onready var camera = $PhantomCamera2D
@onready var forward_raycast:RayCast2D = $RayCast2D
@onready var player_ui = $player_ui
@onready var heart_particales = $GPUParticles2D
@onready var dash_particles = $DashParticles
@onready var fast_fall_particles = $FastFallParticles
#Audio Onreadies
@onready var sfx_jump: AudioStreamPlayer = $sfx_jump
@onready var sfx_wallkick: AudioStreamPlayer = $sfx_wallkick
@onready var sfx_land: AudioStreamPlayer = $sfx_land
@onready var sfx_splat: AudioStreamPlayer = $sfx_splat
@onready var sfx_dash: AudioStreamPlayer = $sfx_dash


# Flow, increases top speed
var flow:float = 0

var last_velocity:Vector2
var coyote_time:float = 0
var stunned:bool = false
var on_wall:bool = false
var using_flow:bool = false

func is_on_coyote_floor(delta:float) -> bool:
	if is_on_floor():
		coyote_time = 0
		return true
	coyote_time += delta
	return coyote_time < COYOTE_LENGTH

func _physics_process(delta):
	rotate_raycast()
	check_stun()
	apply_gravity(delta)
	handle_input(delta)
	camera.follow_offset = velocity * Vector2(.2,.1)
	if not is_zero_approx(velocity.x):
		last_velocity = velocity
	move_and_slide()
	check_flow_state()

func handle_input(delta:float):
	var jump_input:bool = Input.is_action_just_pressed("jump")
	if is_on_coyote_floor(delta):
		if jump_input:
			jump()
			sfx_jump.play()
		else:
			apply_horizontal_movement(delta, 1)
	else:
		if using_flow:
			apply_horizontal_movement(delta, 2)
			
		if jump_input and forward_raycast.is_colliding():
			velocity.x = get_top_speed() * -sign(last_velocity.x)
			jump()
			sfx_wallkick.play()
		if Input.is_action_just_pressed("fast_fall"):
			velocity.y += JUMP_SPEED
			fast_fall_particles.emitting = true
			
	if Input.is_action_pressed("use_flow") and not is_zero_approx(player_ui.flow_bar.value) and not is_on_floor():
		flow += FLOW_BUILD_RATE
		player_ui.flow_bar.value -= 2
		heart_particales.emitting = true
		using_flow = true
	else:
		heart_particales.emitting = false
		using_flow = false
		flow = max(0, flow-FLOW_DECAY_RATE)
		
	if Input.is_action_just_pressed("dash"):
		dash()

func apply_horizontal_movement(delta:float, multiplier:float=1):
	var new_direction = get_input_direction()
	var new_velocity:float = new_direction * SPEED * delta * 1000.
	if abs(velocity.x + new_velocity) < get_top_speed():
		if new_direction != sign(last_velocity.x):
			new_velocity *= 2
		velocity.x += new_velocity
	
func get_top_speed():
	return min(TOP_FLOW_SPEED, TOP_SPEED + flow)
	
func apply_gravity(delta:float):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func check_stun():
	var movement_direction:int = sign(velocity.x)
	if movement_direction == 0:
		var on_floor:bool = is_on_floor()
		if abs(last_velocity.x) >= TOP_SPEED-SLAM_SENSITIVITY and on_floor:
			stunned = true
			on_wall = false
		elif not on_floor:
			on_wall = true
	else:
		stunned = false
		on_wall = false

func dash():
#	Gets the direction of the dash, fun fact Input.get_vector() has a weird bug where it's slightly off tilt.
#	I aint dealing with that issue again.
	if not player_ui.flow_bar.value == 100:
		return
	dash_particles.emitting = true
	velocity.x = DASH_SPEED * sign(last_velocity.x)
	velocity.y = 0
	player_ui.flow_bar.value = 0
	sfx_dash.play()
	

func jump():
	stunned = false
	velocity.y = -JUMP_SPEED
	coyote_time = 10
	
func get_input_direction() -> int:
	return sign(Input.get_axis("move_left", "move_right"))

func rotate_raycast():
	forward_raycast.target_position.x = WALL_DISTANCE * sign(last_velocity.x)

func is_flow_speed() -> bool:
	return abs(velocity.x) > TOP_SPEED * FLOW_SPEED_PERCENT

func check_flow_state():
	if is_flow_speed() and is_on_floor():
		player_ui.flow_bar.value += 1
