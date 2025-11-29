extends Control


@export var first_scene: PackedScene
@export var continue_button: Button


func _ready() -> void:
	continue_button.disabled = not Main.can_continue()


func _on_new_game_button_pressed() -> void:
	Main.load_map(first_scene.resource_path)


func _on_continue_button_pressed() -> void:
	Main.load_continue_map()


func open_main_menu() -> void:
	ResourceLoader.load_threaded_request(scene_file_path)

	await MapTransition.play_exit_map()
	
	get_tree().change_scene_to_packed(
		ResourceLoader.load_threaded_get(scene_file_path)
	)
	
	HUD.visible = false
	await MapTransition.play_enter_map()
