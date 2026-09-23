shader_type canvas_item;

uniform int current_frame = 0;
uniform int total_frames = 4;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Swap UV.x and UV.y to rotate the vertical texture 90 degrees counter-clockwise,
    // aligning tall 32x64 frames perfectly with the direction of the line.
    // We also flip y (1.0 - UV.x) because of some stupid Godot quirk.
    vec2 rotated_uv = vec2(UV.y, 1.0 - UV.x);
    
    // Scale and shift our new horizontal-aligned coordinate to isolate the correct frame
    vec2 frame_uv = vec2(
        (fract(rotated_uv.x) + float(current_frame)) / float(total_frames), 
        rotated_uv.y);
    
    // Output the color of that specific slice
    COLOR = texture(TEXTURE, frame_uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
