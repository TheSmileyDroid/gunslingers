shader_type canvas_item;

uniform vec4 blink_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Color of the blink
uniform float blink_intensity : hint_range(0.0, 1.0) = 0.0; // Intensity of the blink (0 = no blink, 1 = full blink)

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	vec4 final_color = mix(tex_color, blink_color, blink_intensity);
	COLOR = final_color * COLOR; // Multiply by the base color for tinting
}