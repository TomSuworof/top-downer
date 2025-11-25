class_name Detector
extends Area2D

signal validity_changed(valid: bool)

## Colors for detector when its disabled and enabled
@export_color_no_alpha var invalid_color := Color.RED
@export_color_no_alpha var valid_color := Color.GREEN

@export_range(0.0, 1.0) var pulse_frequence := 0.25

@export var sprite := Sprite2D


var _object_count := 0

var _pulse_progress := 0.0


func _init() -> void:
	_pulse_progress = randf()


func _process(delta: float) -> void:
	if _object_count == 0:
		_pulse_progress += delta * pulse_frequence
		if _pulse_progress >= 1:
			_pulse_progress = 0
		var brightness := cos(_pulse_progress * TAU) # from -1 to 1
		brightness = brightness * 0.25 + 0.75 # from 0.5 to 1
		sprite.modulate = Color(
			invalid_color.r * brightness,
			invalid_color.g * brightness,
			invalid_color.b * brightness
		)
		


func _on_body_entered(_body: Node2D) -> void:
	if _object_count == 0:
		sprite.modulate = valid_color
		validity_changed.emit(true)
	_object_count += 1


func _on_body_exited(_body: Node2D) -> void:
	_object_count -= 1
	if _object_count == 0:
		_pulse_progress = 0
		validity_changed.emit(false)
