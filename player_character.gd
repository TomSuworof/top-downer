class_name PlayerCharacter
extends InteractiveObject

## Speed in pixels per second.
@export_range(0, 1000) var speed := 60

@export var joystick: Joystick

var last_position: Vector2
var travel_distance := 0.0


func _ready() -> void:
	last_position = position
	joystick.visible = DisplayServer.is_touchscreen_available()


func _physics_process(_delta: float) -> void:
	get_player_input()
	if move_and_slide():
		resolve_collisions()

	travel_distance += last_position.distance_to(position)
	last_position = position
	

func _process(_delta: float) -> void:
	HUD.show_travel_distance(travel_distance)
	
	
func get_player_input() -> void:
	var vector: Vector2
	if joystick.visible:
		vector = joystick.get_joystick_direction()
	else:
		vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = vector * speed


func resolve_collisions() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider()
		if body is MovableObject:
			body.apply_impact(velocity)


func displace(offset: Vector2) -> void:
	super(offset)
	last_position = position
