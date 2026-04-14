shader_type canvas_item;

// Controls for your spaceship panel
uniform vec4 cyan_tint : source_color = vec4(0.0, 0.9, 0.9, 0.1);
uniform float scanline_speed : hint_range(0.0, 2.0) = 0.1;
uniform float static_speed : hint_range(0.0, 50.0) = 10.0;
uniform float line_density : hint_range(10.0, 1000.0) = 600.0;
uniform float jitter_amount : hint_range(0.0, 0.05) = 0.002;

// Function to generate procedural "Static" noise
float noise(vec2 uv, float time) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233) + time)) * 43758.5453);
}

void fragment() {
    vec2 uv = UV;

    // 1. ANIMATED SCREEN JITTER
    // Randomly shifts the screen slightly left/right over time for that "unstable" look
    float jitter = (noise(vec2(TIME, 0.0), TIME) - 0.5) * jitter_amount;
    uv.x += jitter;

    // 2. ANIMATED SCANLINES
    // We use TIME multiplied by scanline_speed to make the lines "roll" down the screen
    float rolling_lines = sin((uv.y + TIME * scanline_speed) * line_density);
    rolling_lines = clamp(rolling_lines, 0.7, 1.0);

    // 3. ANIMATED STATIC GRAIN
    // The noise changes every frame based on TIME * static_speed
    float grain = noise(uv, floor(TIME * static_speed));
    
    // 4. THE "TUBE" VIGNETTE
    // Darkens the corners to look like a glass display
    float vignette = 1.0 - distance(uv, vec2(0.5)) * 0.2;

    // 5. SCREEN PULSE (FLICKER)
    // Makes the brightness breathe slightly
    float pulse = 0.95 + 0.05 * sin(TIME * 10.0);

    // COMBINE EVERYTHING
    vec3 final_color = cyan_tint.rgb;
    final_color *= rolling_lines;       // Add the lines
    final_color *= mix(0.9, 1.1, grain); // Add the grain texture
    final_color *= vignette;            // Add corner darkness
    final_color *= pulse;               // Add the brightness flicker

    // Output with the original alpha (transparency)
    COLOR = vec4(final_color, 0.2);
}