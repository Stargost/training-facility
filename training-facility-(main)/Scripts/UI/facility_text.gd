extends Control

@export var window_size: Vector2 = Vector2(128, 128)
# The size of the margin. It substract 10 to the size on both ends of the axis (so for example, 10 would
# substract 20 in total.
@export var margin_size: Vector2 = Vector2(10, 10)
## The value to be called. Must match something in the CSV files.
@export var callable_text: String
@export var font_size: int = 12
## Determine which horizontal allignment method to use. 0 = Left; 1 = Center; 2 = Right; 3 = Fill.
@export var h_alignment: int = 0

@onready var nine_slicy = $NinePatchRect
@onready var texto = $NinePatchRect/RichTextLabel

func _ready() -> void:
	nine_slicy.size = window_size
	texto.add_theme_font_size_override("normal_font_size", font_size)
	# Handle the margin calculations.
	texto.size = window_size
	texto.size.x -= margin_size.x * 2
	texto.size.y -= margin_size.y * 2
	texto.position += Vector2(margin_size.x, margin_size.y)
	texto.horizontal_alignment = h_alignment
	texto.text = callable_text
