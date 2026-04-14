shader_type canvas_item;

uniform vec4 shine_color : source_color = vec4(0.0, 0.5, 0.5, 0.1); // Slight blue
uniform float cycle_speed : hint_range(0.0, 10.0) = 2.0;
uniform float wave_count : hint_range(0.0, 20.0) = 3.0;
uniform float wave_intensity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    // Get the base texture color
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Create the diagonal flow logic
    // (UV.x + UV.y) creates a flow from Top-Left to Bottom-Right
    // (UV.x - UV.y) creates a flow from Bottom-Left to Top-Right
    // To flow Right-Up to Left-Down, we use:
    float diagonal = UV.x + (1.0 - UV.y);
    
    // Create the smooth wave using sine
    // TIME * cycle_speed moves the wave over time
    float wave = sin(diagonal * wave_count + TIME * cycle_speed);
    
    // Smooth the wave out so it's not a harsh flicker
    wave = (wave + 1.0) * 0.5; 
    
    // Mask the shine so it only appears on the visible parts of the object
    float final_shine = wave * wave_intensity * tex_color.a;
    
    // Add the blue shine color to the original texture
    COLOR = tex_color + (shine_color * final_shine);
}