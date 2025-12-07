class_name InteractiveObject
extends CharacterBody2D

@export var collission_shape: CollisionShape2D


func displace(offset: Vector2) -> void:
	self.position += offset


func get_current_rect() -> Rect2:
	var rect := collission_shape.shape.get_rect()
	rect.position += self.position
	return rect
