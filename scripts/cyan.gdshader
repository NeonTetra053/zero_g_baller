shader_type canvas_item;

uniform vec3 cyan_color : source_color = vec3(0.0, 1.0, 1.0);
uniform float contrast : hint_range(0.5, 2.0) = 1.2;
uniform float brightness : hint_range(-0.5, 0.5) = 0.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// Convert to grayscale (perceptual)
	float gray = dot(tex.rgb, vec3(0.299, 0.587, 0.114));

	// Adjust contrast & brightness
	gray = (gray - 0.5) * contrast + 0.7 + brightness;
	gray = clamp(gray, 0.0, 1.0);

	// Map grayscale to cyan
	vec3 color = cyan_color * gray;

	COLOR = vec4(color, tex.a);
}