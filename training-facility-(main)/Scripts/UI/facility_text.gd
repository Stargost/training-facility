extends Control

## Grants extra size for the 9 slice object. Added at the end.
@export var extra_9s_size: Vector2 = Vector2(0, 0)
## Limits the size on either the X or Y axis. Leave at -1 for no limit. May act weirdly if X is -1.
@export var size_limiter: Vector2 = Vector2(-1, -1)
## The size of the margin. It substracts 10 to the size on both ends of the axis (so for example, 10 would
## substract 20 in total.
@export var margin_size: Vector2 = Vector2(10, 10)
## The value to be called. Must match something in the CSV files.
@export var callable_text: String = "NaN"
@export var font_size: int = 12
## Determine which horizontal allignment method to use. 0 = Left; 1 = Center; 2 = Right; 3 = Fill.
@export var h_alignment: int = 0

@onready var nine_slicy := $NinePatchRect
@onready var texto := $NinePatchRect/RichTextLabel
@onready var collisioner := $Area2D/CollisionShape2D

func _ready() -> void:
	texto.add_theme_font_size_override("normal_font_size", font_size)
	texto.custom_maximum_size = size_limiter
	#print(texto.get_minimum_size())
	
	if "NaN" not in callable_text:
		texto.text = callable_text
	
	# Margin calculations
	texto.size.x -= margin_size.x * 2
	texto.size.y -= margin_size.y * 2
	texto.position += Vector2(margin_size.x, margin_size.y) / 2
	texto.horizontal_alignment = h_alignment
	#print(texto.get_minimum_size())
	
	nine_slicy.size = texto.get_minimum_size() + margin_size
	nine_slicy.size.y += margin_size.y
	nine_slicy.size += extra_9s_size
	
	collisioner.shape.size = (nine_slicy.size - Vector2(20, 20))
	collisioner.position = (nine_slicy.size / 2)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		modulate = Color(1.0, 1.0, 1.0, 0.4) # This is here solely for the level 1 glyphs
		var shader_param = self.material as ShaderMaterial
		shader_param.set_shader_parameter("alpha", 0.3)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		modulate = Color(1.0, 1.0, 1.0, 1.0) # Consult the function above
		var shader_param = self.material as ShaderMaterial
		shader_param.set_shader_parameter("alpha", 0.75)
