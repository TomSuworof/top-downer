class_name InteractiveObject
extends CharacterBody2D

@export var collission_shape: CollisionShape2D


func displace(offset: Vector2) -> void:
	self.position += offset


func get_current_rect() -> Rect2:
	var rect := collission_shape.shape.get_rect()
	rect.position += self.position
	return rect


func push(push_velocity: Vector2) -> void:
	velocity.x = _push(velocity.x, push_velocity.x)
	velocity.y = _push(velocity.y, push_velocity.y)


func _push(speed: float, push_speed: float) -> float:
	if push_speed >= 0.0 and speed >= 0.0:
		# Both positive, pick strongest
		return max(speed, push_speed)
	elif push_speed < 0.0 and speed < 0.0:
		# Both negative, pick strongest
		return min(speed, push_speed)
		
	return speed + push_speed
