extends Node

var level_list

func _ready() -> void:
	Console.pause_enabled = true
	
	Console.add_command("map", console_map, ["target map"], 1, "Change map to 'target map'")
	Console.add_command("restart", console_restart, 0, 0, "Reloads the current level")
	Console.add_command("suicide", console_suicide, 0, 0, "Kills the player")
	Console.add_command("perform", console_play_sound, ["target sound"], 1, "Play a sound within the SFX folder")
	Console.add_command("wipe_config", console_wipe_config, ["confirm"], 0, "Wipes the data in the config file.")
	Console.add_command("wipe_savedata", console_wipe_savefile, ["confirm"], 0, "Wipes the data in the save file")
	Console.add_command("save_config", console_save_config, 0, 0, "Saves the current configuration file")
	Console.add_command("save_savefile", console_save_savefile, 0, 0, "Saves the game")
	#Console.add_command("show_hitboxes", console_enable_hitboxes, ["bool"], 1, "Displays hitboxes of all objects")

func console_map(mapa):
	if GlobalBus.level_list.is_empty():
		GlobalBus.scan_levels()
	level_list = GlobalBus.level_list
	
	if mapa not in level_list:
		Console.print_error("Invalid map name")
		return
	var pointer = level_list[mapa]
	get_tree().change_scene_to_file(pointer)

func console_restart():
	get_tree().reload_current_scene()

func console_suicide():
	GlobalBus.player_killed.emit()
	SfxHandler.play_sfx("thunder.mp3")

func console_play_sound(target):
	var sfxes = GlobalBus.extract_SFX_list()
	if ".mp3" not in target:
		target = str(target) + ".mp3"
	var play_index = sfxes.find(target)
	var play_shit = sfxes.get(play_index)
	SfxHandler.play_sfx(play_shit)

func console_wipe_config(value: String):
	var i = false
	if value == "true":
		i = true
	else:
		print("If you are actually trying to execute the command, second argument must be 'true'")
	GlobalBus.wipe_config_data(i)

func console_wipe_savefile(value: String):
	var i = false
	if value == "true":
		i = true
	else:
		print("If you are actually trying to execute the command, second argument must be 'true'")
	GlobalBus.wipe_save_data(i)

func console_save_config():
	GlobalBus.save_configfile()

func console_save_savefile():
	GlobalBus.save_savefile()

func console_enable_hitboxes(arg: bool):
	#TODO: Find a way to actually implement this. Preferably without iterating over every object in the scene
	pass
