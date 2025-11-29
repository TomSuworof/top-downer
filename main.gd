extends Node


const MAP_PATH_PREFIX := "res://maps"

const GAME_SAVE_PATH := "user://top-downer.save"

const KEY_GAME_SAVE_VERSION := "version"
const GAME_SAVE_VERSION := 1
const KEY_MAP_PATH := "map_path"
const KEY_PER_MAP_DATA := "per_map_data"


var game_save_data: Dictionary


func _ready() -> void:
	if FileAccess.file_exists(GAME_SAVE_PATH):
		var game_save_file := FileAccess.open(GAME_SAVE_PATH, FileAccess.READ)
		game_save_data = game_save_file.get_var() as Dictionary
		if not game_save_data.has(KEY_PER_MAP_DATA):
			game_save_data[KEY_PER_MAP_DATA] = {}
		if game_save_data[KEY_GAME_SAVE_VERSION] > GAME_SAVE_VERSION:
			print("Tried to load unknown future save file format!")
			game_save_data = {}
	
	game_save_data[KEY_GAME_SAVE_VERSION] = GAME_SAVE_VERSION
	if not game_save_data.has(KEY_PER_MAP_DATA):
		game_save_data[KEY_PER_MAP_DATA] = {}


func can_continue() -> bool:
	return game_save_data.has(KEY_MAP_PATH)
	

func load_continue_map() -> void:
	if not can_continue():
		print("Tried to continue without a save file!")
		return
	
	var map_path := game_save_data[KEY_MAP_PATH] as String
	
	if not map_path.begins_with(MAP_PATH_PREFIX) or map_path.contains(".."):
		print("Unknown map path")
		return
	
	load_map(map_path)


func load_next_map() -> void:
	var split_path := (game_save_data.get(KEY_MAP_PATH) as String).split('.')
	var next_map_number := split_path[1].to_int() + 1
	split_path[1] = str(next_map_number).pad_zeros(3)
	var next_map_path := '.'.join(split_path)
	
	if not ResourceLoader.exists(next_map_path):
		exit_to_main_menu()
		return
	
	load_map(next_map_path)


func load_map(map_path: String) -> void:
	ResourceLoader.load_threaded_request(map_path)
	
	get_tree().paused = true
	await MapTransition.play_exit_map()
	
	get_tree().change_scene_to_packed(
		ResourceLoader.load_threaded_get(map_path)
	)
	
	await MapTransition.play_enter_map()
	get_tree().paused = false


func map_loaded(map: GameMap) -> void:
	var map_path := map.scene_file_path
	game_save_data[KEY_MAP_PATH] = map_path
	var per_map_data := game_save_data[KEY_PER_MAP_DATA] as Dictionary
	if not per_map_data.has(map_path):
		per_map_data[map_path] = {}
	map.map_save_data = per_map_data[map_path]
	var game_save_file := FileAccess.open(GAME_SAVE_PATH, FileAccess.WRITE)
	game_save_file.store_var(game_save_data)


func exit_to_main_menu() -> void:
	var menu_scene = MainMenu.scene_file_path
	ResourceLoader.load_threaded_request(menu_scene)

	await MapTransition.play_exit_map()
	
	get_tree().change_scene_to_packed(
		ResourceLoader.load_threaded_get(MainMenu.scene_file_path)
	)
	
	HUD.visible = false
	await MapTransition.play_enter_map()
