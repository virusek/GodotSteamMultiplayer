shader_type canvas_item;

uniform float transparency_factor : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    col.a *= transparency_factor; // Adjust alpha based on the transparency factor
    COLOR = col;
}