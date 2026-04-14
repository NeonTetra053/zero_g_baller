shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform float radius : hint_range(0.0, 10.0) = 1.0;
uniform float intensity : hint_range(0.0, 5.0) = 1.0;

void fragment() {
    vec2 size = TEXTURE_PIXEL_SIZE;
    float alpha = 0.0;
    
    // Smooth Gaussian-like blur loop
    // This samples a 5x5 grid around each pixel to create softness
    for (float x = -2.0; x <= 2.0; x++) {
        for (float y = -2.0; y <= 2.0; y++) {
            vec2 offset = vec2(x, y) * size * radius;
            alpha += texture(TEXTURE, UV + offset).a;
        }
    }
    
    // Divide by number of samples (25) and apply intensity
    alpha = (alpha / 25.0) * intensity;
    
    vec4 texture_color = texture(TEXTURE, UV);
    
    // Draw the blurred glow behind the original texture
    // If the pixel is part of the sprite, show the sprite. 
    // Otherwise, show the glow color with the calculated alpha.
    vec3 final_color = mix(glow_color.rgb, texture_color.rgb, texture_color.a);
    float final_alpha = max(texture_color.a, alpha);
    
    COLOR = vec4(final_color, final_alpha);
}