shader_type canvas_item;

uniform float wave_strength = 5.0;
uniform float wave_speed = 3.0;
uniform float wave_frequency = 12.0;

void vertex() {
    VERTEX.y += sin(
        VERTEX.x * wave_frequency * 0.01 +
        TIME * wave_speed
    ) * wave_strength;
}