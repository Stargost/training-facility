extends Node

var sfx_list
var music_list
var folder_path = "res://SFX/"
var music_folder_path = "res://Music/"
@onready var sounding = $AudioStreamPlayer
@onready var sounding0 = $AudioStreamPlayer2
@onready var music_channel = $AudioStreamPlayer3
@onready var special_channel = $special_channel
var last_song

func _ready() -> void:
	sfx_list = GlobalBus.extract_SFX_list()
	music_list = GlobalBus.extract_music_list()

func play_sfx(pointer: String, volume: float = 1.0, force_channel: int = -1):
	var destination = folder_path.path_join(pointer)
	
	var file = ResourceLoader.load(destination)
	if volume >= 0.0:
		sounding.volume_linear = volume
		sounding0.volume_linear = volume
		if force_channel == 2:
			special_channel.volume_linear = volume
	elif volume < 0.0:
		printerr("Cannot assign volume level if value is negative.")
	sounding.volume_linear *= GlobalBus.volume_level
	sounding0.volume_linear *= GlobalBus.volume_level
	special_channel.volume_linear *= GlobalBus.volume_level
	# Play the SFX
	if force_channel >= 0:
		match force_channel:
			0:
				sounding.stream = file
				sounding.play()
			1:
				sounding0.stream = file
				sounding0.play()
			2:
				special_channel.stream = file
				special_channel.play()
	else:
		if not sounding.playing:
			sounding.stream = file
			sounding.play()
		elif sounding.playing and sounding.stream == file:
			sounding.play()
		elif sounding.playing and sounding.stream != null:
			sounding0.stream = file
			sounding0.play()

func play_song(pointer: String, volume: float = 1.0):
	var destination = music_folder_path.path_join(pointer)
	var file = ResourceLoader.load(destination)
	music_channel.volume_linear = volume
	music_channel.volume_linear *= GlobalBus.volume_level
	
	music_channel.stream = file
	music_channel.play()
	match pointer:
		"song_1.ogg":
			last_song = 0
		"song_2.ogg":
			last_song = 1
		"song_3.ogg":
			last_song = 2

func _on_audio_stream_player_3_finished() -> void:
	var ii = "res://Music/menu.ogg"
	if music_channel.stream.resource_path == ii:
		play_song("menu.ogg")
		return
	var i = randi_range(0, 2)
	var song_array = ["song_1.ogg", "song_2.ogg", "song_3.ogg"]
	if i == last_song:
		match last_song:
			0 or 1:
				i += 1
			2:
				i = 0
	var send_it = song_array[i]
	play_song(send_it)

func stop_sfx(stop_all: bool, target_channel: int = 0):
	if stop_all == true:
		sounding.stop()
		sounding0.stop()
		special_channel.stop()
	else:
		match target_channel:
			0:
				sounding.stop()
			1:
				sounding0.stop()
			2:
				special_channel.stop()

func stop_music():
	music_channel.stop()
