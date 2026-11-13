extends Node2D

# I have to make this stupid script because for some reason starting the animation
# through Godot's SpriteFrames window causes them to be off-sync.

@onready var l_glyph := $left_glyph
@onready var r_glyph := $right_glyph
@onready var up_glyph := $jump_glyph
@onready var A_glyph := $left_2_glyph
@onready var D_glyph := $right_2_glyph
@onready var W_glyph := $W_glyph
@onready var spacebar_glyph := $spacebar_glyph
@onready var player_move_glyph := $player_move_glyph
@onready var player_jump_glyph := $player_jump_glyph

var glyphs: Array

func _ready() -> void:
	glyphs = [l_glyph, r_glyph, up_glyph, A_glyph, D_glyph, W_glyph, spacebar_glyph, player_move_glyph, player_jump_glyph]
	for i in glyphs:
		i.play("default")
