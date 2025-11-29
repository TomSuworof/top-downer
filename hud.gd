extends CanvasLayer


@export var map_name_label: Label


func _ready() -> void:
	self.visible = false


func show_map_info(map: GameMap) -> void:
	map_name_label.text = map.map_name
	self.visible = true
