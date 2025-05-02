class_name Ship extends Node2D

@export var planet: Planet
@export_enum('p1', 'p2') var player: String = 'p1'
@export var speed: int = 2
@export var rotation_speed: int = 10
@export var torpedo_spawner: Spawner2D

@onready var destructor_2d: Destructor2D = $Destructor2D
@onready var spawn_point: Vector2 = position

var steering: float = 0.0
var throttle: float = 0.0
var velocity: Vector2 = Vector2.ZERO
var velocity_max: float = 3

func _process(delta: float) -> void:
	accelerate(delta)
	apply_gravity(delta)
	steer(delta)
	
	position += velocity
	
	screen_wrap()

func _ready() -> void:
	destructor_2d.destroyed.connect(func(): call_deferred('despawn'))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(player + '_fire'):
		torpedo_spawner.spawn(position + (self.transform.x * 10), self.transform.x)

func accelerate(delta: float) -> void:
	throttle = -Input.get_axis(player + '_up', player + '_down')
	velocity += self.transform.x * throttle * speed * delta
	velocity = velocity.clamp(Vector2(-velocity_max, -velocity_max), Vector2(velocity_max, velocity_max))

func apply_gravity(delta: float) -> void:
	if planet == null:
		return
	var gravity_force = planet.get_gravity_force(position)
	velocity += gravity_force * delta

func despawn() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

func reset() -> void:
	position = spawn_point
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT

func screen_wrap() -> void:
	position.x = wrapf(position.x, 0, 512)
	position.y = wrapf(position.y, 0, 512)

func steer(delta: float) -> void:
	steering = Input.get_axis(player + '_left', player + '_right')
	rotate(steering * rotation_speed * delta)
