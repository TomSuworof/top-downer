extends Node

var registered_detectors_count := 0
var valid_detectors_count := 0


func _ready() -> void:
	for child_node in get_children():
		if child_node is Detector:
			var detector := child_node as Detector
			registered_detectors_count += 1
			detector.validity_changed.connect(_on_detector_validity_changed)


func _on_detector_validity_changed(valid: bool) -> void:
	if valid:
		valid_detectors_count += 1
		if valid_detectors_count == registered_detectors_count:
			load_next_map.call_deferred()
	else:
		valid_detectors_count -= 1 


func load_next_map() -> void:
	var current_map_path := get_tree().current_scene.scene_file_path
	var split_path := current_map_path.split('.')
	var next_map_number := split_path[1].to_int() + 1
	split_path[1] = str(next_map_number).pad_zeros(3)
	var next_map_path := '.'.join(split_path)
	if not ResourceLoader.exists(next_map_path):
		split_path[1] = '001'
		next_map_path = '.'.join(split_path)
	get_tree().change_scene_to_file(next_map_path)
	
