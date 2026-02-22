class_name Joystick
extends CanvasLayer


@export var joystick_background: TouchScreenButton
@export var joystick_knob: Node2D

var max_distance: float
var joystick_center: Vector2
var touched := false


func _ready() -> void:
	max_distance = joystick_background.shape.radius
	joystick_center = joystick_background.texture_normal.get_size() / 2
	set_process(false)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch_event = (event as InputEventScreenTouch)
		if touch_event.position.distance_to(joystick_background.global_position) > max_distance:
			return
		if event.pressed:
			set_process(true)
		elif not event.pressed:
			set_process(false)
			joystick_knob.position = joystick_center
			
			
func _process(_delta: float) -> void:
	joystick_knob.global_position = get_viewport().get_mouse_position()
	joystick_knob.position = joystick_center + (joystick_knob.position - joystick_center).limit_length(max_distance)
	
	
func get_joystick_direction() -> Vector2:
	return (joystick_knob.position - joystick_center).normalized()
	
