shader_type canvas_item;

uniform float reveal : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    // UV goes 0 (top) → 1 (bottom) across the Control node
    if (UV.y > reveal) {
        discard; // hide everything below the reveal line
    }
    // Keep children visible
    COLOR = vec4(1.0,1.0,1.0,1.0);
}