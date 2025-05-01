class_name Ship extends Node2D

@export_enum('p1', 'p2') var player: String = 'p1'
@export var speed: int = 2
@export var rotation_speed: int = 10

var steering: float = 0.0
var throttle: float = 0.0
var velocity: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	accelerate(delta)
	steer(delta)

func accelerate(delta: float) -> void:
	throttle = -Input.get_axis(player + '_up', player + '_down')
	velocity += self.transform.x * throttle * speed * delta
	position += velocity

func steer(delta: float) -> void:
	steering = Input.get_axis(player + '_left', player + '_right')
	rotate(steering * rotation_speed * delta)
