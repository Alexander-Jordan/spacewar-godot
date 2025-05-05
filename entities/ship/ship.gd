class_name Ship extends Node2D

@export var planet: Planet
@export_enum('p1', 'p2') var player: String = 'p1'
@export var speed: int = 2
@export var rotation_speed: int = 10
@export var torpedo_spawner: Spawner2D

@onready var destructor_2d: Destructor2D = $Destructor2D
@onready var gpu_particles_explosion: GPUParticles2D = $gpu_particles_explosion
@onready var gpu_particles_thrust: GPUParticles2D = $gpu_particles_thrust
@onready var random_audio_player_2d: RandomAudioPlayer2D = $RandomAudioPlayer2D
@onready var spawn_point: Vector2 = position
@onready var spawn_rotation: float = rotation
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var thrust_audio_stream_player: ThrustAudioStreamPlayer = $ThrustAudioStreamPlayer
@onready var timer: Timer = $Timer

var is_spawned: bool = true
var steering: float = 0.0
var throttle: float = 0.0
var throttle_forward: bool = false:
	set(tf):
		if tf == throttle_forward:
			return
		throttle_forward = tf
		if tf:
			thrust_audio_stream_player.start_thrust()
		else:
			thrust_audio_stream_player.end_thrust()
		gpu_particles_thrust.emitting = tf
var velocity: Vector2 = Vector2.ZERO
var velocity_max: float = 3

func _process(delta: float) -> void:
	accelerate(delta)
	apply_gravity(delta)
	steer(delta)
	
	position += velocity
	
	screen_wrap()

func _ready() -> void:
	destructor_2d.destroyed.connect(func(): gpu_particles_explosion.emitting = true; call_deferred('despawn'))
	GM.state_changed.connect(func(state: GM.State):
		match state:
			GM.State.PLAYING:
				reset()
	)
	timer.timeout.connect(reset)
	
	gpu_particles_explosion.modulate = self.modulate
	gpu_particles_thrust.modulate = self.modulate

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(player + '_fire'):
		torpedo_spawner.spawn(position + (self.transform.x * 10), self.transform.x)

func accelerate(delta: float) -> void:
	throttle = -Input.get_axis(player + '_up', player + '_down')
	throttle_forward = throttle > 0
	velocity += self.transform.x * throttle * speed * delta
	velocity = velocity.clamp(Vector2(-velocity_max, -velocity_max), Vector2(velocity_max, velocity_max))

func apply_gravity(delta: float) -> void:
	if planet == null:
		return
	var gravity_force = planet.get_gravity_force(position)
	velocity += gravity_force * delta

func despawn() -> void:
	if !is_spawned:
		return
	
	if player == 'p1':
		GM.lives_p1 -= 1
	else:
		GM.lives_p2 -= 1
	random_audio_player_2d.play_random_audio_and_await_finished()
	thrust_audio_stream_player.stop()
	throttle_forward = false
	sprite_2d.visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	timer.start()
	is_spawned = false

func reset() -> void:
	rotation = spawn_rotation
	position = spawn_point
	velocity = Vector2.ZERO
	sprite_2d.visible = true
	process_mode = Node.PROCESS_MODE_INHERIT
	is_spawned = true

func screen_wrap() -> void:
	position.x = wrapf(position.x, 0, 512)
	position.y = wrapf(position.y, 0, 512)

func steer(delta: float) -> void:
	steering = Input.get_axis(player + '_left', player + '_right')
	rotate(steering * rotation_speed * delta)
