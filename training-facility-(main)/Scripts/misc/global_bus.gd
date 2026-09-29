extends Node

signal card_picked
signal cards_depleted
signal player_reset
signal player_killed
signal check_brightness
signal flip_now

# CONFIG FILE VARIABLES
# Gameplay
var silly_mode: bool = false
var respawn_speed: int = 0
# Audio
var volume_level: float = 1
# Screen
var brightness: float = 100
# Miscellaneous
var language_selected: String = "en"
var enable_start_cutscene: bool = true

# SAVE FILE VARIABLES
# General
var difficulty: String = "normal"
var last_level: String 
var game_won: bool = false
var game_won_on_hard: bool = false
# Stats
var post_reset_deaths: int = 0
var total_deaths: int = 0
var was_game_saved: bool = false


var level_list: Dictionary = {}
var begin_up_timer: bool = false
# Only counts current playthrough.
var total_time: float = 0.0

func _ready() -> void:
	scan_levels()

func _process(delta: float) -> void:
	if begin_up_timer == true:
		total_time += delta

func scan_levels():
	var path = "res://Scenes/Levels/"
	var dir = DirAccess.open(path)
	
	if not dir:
		push_error("Failed to open level file path: " + str(path))
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	 
	while file_name != "":
		if not dir.current_is_dir() and not file_name.begins_with("."):
			# handle export case where Godot changes extension.
			if file_name.ends_with(".remap"):
				file_name = file_name.trim_suffix(".remap")
			
			if file_name.ends_with(".tscn") or file_name.ends_with(".scn"):
				var full_path = path.path_join(file_name)
				var id = extract_level_id(file_name)
				
				# Insert level ID and full path into the dictionary with format ""ID (str)": "FILE_PATH" (str)"
				level_list[id] = full_path
		file_name = dir.get_next()
	dir.list_dir_end()

func extract_level_id(file_name: String) -> Variant:
	# 1. Strip the extension (e.g., "level_esp12.tscn" -> "level_esp12")
	var base_name = file_name.get_basename()
	
	# 2. Find the first underscore
	var underscore_index = base_name.find("_")
	
	if underscore_index == -1:
		# Fallback if there is no underscore in the name
		return base_name 
		
	# 3. Extract everything after the first underscore (e.g., "esp12" or "4")
	var id_string = base_name.substr(underscore_index + 1)
	
	return id_string

func extract_SFX_list():
	var dir = ResourceLoader.list_directory("res://SFX/")
	
	if not dir:
		printerr("Failed to open SFX folder.")
		return
	
	return dir

func extract_music_list():
	var dir = ResourceLoader.list_directory("res://Music/")
	
	if not dir:
		printerr("Failed to open music folder.")
		return
	
	return dir

func save_configfile():
	var configuration = ConfigFile.new()
	var save_path = "user://config.cfg"
	
	# Structure: set_value("section", "key", value)
	# GAMEPLAY
	configuration.set_value("gameplay", "silly_mode", silly_mode)
	configuration.set_value("gameplay", "respawn_speed", respawn_speed)
	# AUDIO
	configuration.set_value("audio", "volume_level", volume_level)
	# SCREEN
	configuration.set_value("screen", "brightness", brightness)
	# MISCELLANEOUS
	configuration.set_value("miscellaneous", "language", language_selected)
	configuration.set_value("miscellaneous", "enable_start_cutscene", enable_start_cutscene)
	
	configuration.save(save_path)

func save_savefile():
	var save_file = ConfigFile.new()
	var save_path = "user://save_file.cfg"
	
	# Structure: set_value("section", "key", value)
	# GENERAL
	save_file.set_value("general", "last_level", last_level)
	save_file.set_value("general", "game_won", game_won)
	save_file.set_value("general", "game_won_on_hard", game_won_on_hard)
	# STATS
	save_file.set_value("stats", "post_reset_deaths", post_reset_deaths)
	save_file.set_value("stats", "total_deaths", total_deaths)
	save_file.set_value("stats", "was_game_saved", was_game_saved)
	
	save_file.save(save_path)

func load_configfile():
	var configuration = ConfigFile.new()
	
	var err = configuration.load("user://config.cfg")
	
	if err != OK:
		return
	
	# GAMEPLAY
	silly_mode = configuration.get_value("gameplay", "silly_mode", false)
	respawn_speed = configuration.get_value("gameplay", "respawn_speed", 0)
	# AUDIO
	volume_level = configuration.get_value("audio", "volume_level", 1)
	# SCREEN
	brightness = configuration.get_value("screen", "brightness", 100)
	# MISCELLANEOUS
	language_selected = configuration.get_value("miscellaneous", "language", "en")
	enable_start_cutscene = configuration.get_value("miscellaneous", "enable_start_cutscene", true)
	
	TranslationServer.set_locale(language_selected)

func load_savefile():
	var save_file = ConfigFile.new()
	
	var err = save_file.load("user://save_file.cfg")
	
	if err != OK:
		return
	
	# General
	last_level = save_file.get_value("general", "last_level", "null")
	game_won = save_file.get_value("general", "game_won", false)
	game_won_on_hard = save_file.get_value("general", "game_won_on_hard", false)
	
	# Stats
	post_reset_deaths = save_file.get_value("stats", "post_reset_deaths", 0)
	total_deaths = save_file.get_value("stats", "total_deaths", 0)
	was_game_saved = save_file.get_value("stats", "was_game_saved", false)

func wipe_config_data(confirm: bool = false):
	if confirm == true:
		var configuration = ConfigFile.new()
		
		var err = configuration.load("user://config.cfg")
		
		if err != OK:
			return
		
		configuration.clear()
		configuration.save("user://config.cfg")
		print("Config data successfully cleared.")

func wipe_save_data(confirm: bool = false):
	if confirm == true:
		var savefile = ConfigFile.new()
		
		var err = savefile.load("user://save_file.cfg")
		
		if err != OK:
			return
		
		savefile.clear()
		savefile.save("user://save_file.cfg")
		print("Save data successfully cleared.")
