shader_type canvas_item;

uniform float glow_strength : hint_range(0.0, 3.0) = 3.0;
uniform vec4 glow_color : source_color = vec4(1.0,1.0,0.5,1.0);

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    COLOR = tex;
    COLOR.rgb += glow_color.rgb * glow_strength * tex.a;
}