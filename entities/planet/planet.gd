class_name Planet extends Node2D

@export var gravity_strength: float = 8000.0

func get_gravity_force(ship_position: Vector2) -> Vector2:
	var direction = global_position - ship_position
	var distance_squared = direction.length_squared()
	if distance_squared == 0:
		return Vector2.ZERO
	return direction.normalized() * gravity_strength / distance_squared
