class_name GameMap
extends Node


const KEY_BEST_TIME := "best_time"

@export var map_name := "Map"


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
			
	Main.map_loaded(self)
	HUD.show_map_info(self)
	
	
func _process(delta: float) -> void:
	current_map_time += delta
	HUD.show_map_time(current_map_time)


func _on_detector_validity_changed(valid: bool) -> void:
	if valid:
		valid_detectors_count += 1
		if valid_detectors_count == registered_detectors_count:
			_update_best_time()
			Main.load_next_map()
	else:
		valid_detectors_count -= 1 
	
	
func _update_best_time() -> void:
	var new_time := floori(current_map_time)
	if not map_save_data.has(KEY_BEST_TIME) or new_time < map_save_data[KEY_BEST_TIME]:
		map_save_data[KEY_BEST_TIME] = new_time
		HUD.show_new_best_map_time(new_time)
