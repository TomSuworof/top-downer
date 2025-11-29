class_name GameMap
extends Node


const KEY_BEST_TIME := "best_time"
const KEY_BEST_TRAVEL_DISTANCE = "best_travel_distance"

@export var map_name := "Map"

var player_character: PlayerCharacter

var registered_detectors_count := 0
var valid_detectors_count := 0
var current_map_time := 0.0
var map_save_data: Dictionary


func _ready() -> void:
	for child_node in get_children():
		if child_node is Detector:
			var detector := child_node as Detector
			registered_detectors_count += 1
			detector.validity_changed.connect(_on_detector_validity_changed)
		elif child_node is PlayerCharacter:
			player_character = child_node
			
	Main.map_loaded(self)
	HUD.show_map_info(self)
	HUD.show_map_detector_count(valid_detectors_count, registered_detectors_count)
	
	
func _process(delta: float) -> void:
	current_map_time += delta
	HUD.show_map_time(current_map_time)


func _on_detector_validity_changed(valid: bool) -> void:
	if valid:
		valid_detectors_count += 1
		HUD.show_map_detector_count(valid_detectors_count, registered_detectors_count)
		if valid_detectors_count == registered_detectors_count:
			_update_best_scores()
			Main.load_next_map()
	else:
		valid_detectors_count -= 1 
	
	
func _update_best_scores() -> void:
	var new_time := floori(current_map_time)
	if (
		not map_save_data.has(KEY_BEST_TIME) 
		or 
		new_time < map_save_data[KEY_BEST_TIME]
	):
		map_save_data[KEY_BEST_TIME] = new_time
	else:
		new_time = -1
	
	var new_travel_distance := floori(player_character.travel_distance)
	if (
		not map_save_data.has(KEY_BEST_TRAVEL_DISTANCE) 
		or 
		new_travel_distance < map_save_data[KEY_BEST_TRAVEL_DISTANCE]
	):
		map_save_data[KEY_BEST_TRAVEL_DISTANCE] = new_travel_distance
	else:
		new_travel_distance = -1

	HUD.show_new_best_map_scores(new_time, new_travel_distance)
