class_name GameMap
extends Node


@export var map_name := "Map"


var registered_detectors_count := 0
var valid_detectors_count := 0


func _ready() -> void:
	for child_node in get_children():
		if child_node is Detector:
			var detector := child_node as Detector
			registered_detectors_count += 1
			detector.validity_changed.connect(_on_detector_validity_changed)
			
	Main.map_loaded(self)
	HUD.show_map_info(self)


func _on_detector_validity_changed(valid: bool) -> void:
	if valid:
		valid_detectors_count += 1
		if valid_detectors_count == registered_detectors_count:
			Main.load_next_map()
	else:
		valid_detectors_count -= 1 
	
