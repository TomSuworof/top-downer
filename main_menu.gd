extends Control


@export var first_scene: PackedScene

@export var continue_button: Button


func _ready() -> void:
	continue_button.disabled = not Main.can_continue()


func _on_new_game_button_pressed() -> void:
	Main.load_map(first_scene.resource_path)


func _on_continue_button_pressed() -> void:
	Main.load_continue_map()
