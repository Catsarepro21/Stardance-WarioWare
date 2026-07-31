shader_type canvas_item;

// Set this in the Inspector to match your background color (e.g., pure green or white)
uniform vec4 key_color : source_color = vec4(0.0, 1.0, 0.0, 1.0); // Default: Green
uniform float threshold : hint_range(0.0, 1.0) = 0.1;

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    if (distance(col.rgb, key_color.rgb) < threshold) {
        col.a = 0.0; // Make background pixel transparent
    }
    COLOR = col;
}