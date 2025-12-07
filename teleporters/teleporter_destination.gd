class_name TeleporterDestination
extends Area2D

signal validity_changed(valid: bool)

@export var sprite: Sprite2D

@export var particles: GPUParticles2D

var objects_count := 0


func _on_body_entered(_body: Node2D) -> void:
	if objects_count == 0:
		validity_changed.emit(false)
	objects_count += 1


func _on_body_exited(_body: Node2D) -> void:
	objects_count -= 1
	if objects_count == 0:
		validity_changed.emit(true)
