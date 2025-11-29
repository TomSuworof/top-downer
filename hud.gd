extends CanvasLayer


@export var map_name_label: Label
@export var map_time_label: Label
@export var traveled_distance_label: Label
@export var map_detector_count_label: Label

@export var new_best_map_scores_label: Label


func _ready() -> void:
	visible = false
	new_best_map_scores_label.visible = false


func show_map_info(map: GameMap) -> void:
	map_name_label.text = map.map_name
	show_map_time(0.0)
	visible = true
	new_best_map_scores_label.visible = false


func show_map_time(time: float) -> void:
	map_time_label.text = "%ds" % time;


func show_new_best_map_scores(time: int, travel_distance: float) ->void:
	var scores_txt := []
	
	if time >= 0:
		scores_txt.push_back("New best time: %ds" % time)
		
	if travel_distance >= 0:
		scores_txt.push_back("New best travel distance: %dpx" % travel_distance)

	new_best_map_scores_label.text = "\n".join(scores_txt)
	new_best_map_scores_label.visible = true


func show_map_detector_count(valid: int, total: int) -> void:
	map_detector_count_label.text = "%d / %d" % [valid, total]
	

func show_travel_distance(distance: float) -> void:
	traveled_distance_label.text = "%dpx" % distance
