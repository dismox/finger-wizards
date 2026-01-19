shader_type canvas_item;

uniform float shadow_angle = 35.0; // в градусах
uniform float shadow_length = 24.0;
uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.5);

void vertex() {
    float angle = radians(shadow_angle);
    float skew = tan(angle);

    // Чем ниже вершина — тем сильнее сдвиг
    float factor = (VERTEX.y);

    VERTEX.x += factor * skew * shadow_length;
    VERTEX.y += shadow_length;
}

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    COLOR = vec4(shadow_color.rgb, tex.a * shadow_color.a);
}
