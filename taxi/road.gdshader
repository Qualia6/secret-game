shader_type canvas_item;

uniform sampler2D tex : repeat_enable;
uniform float a;

void fragment() {
	vec2 UV_ = UV;
	UV_.y *= 2. - UV.y;
	UV_.x += (2. - UV_.y) * (UV.x - 0.5) * 20.;
	COLOR = texture(tex, UV_*vec2(0.1, 1.)+ vec2(a, 0.));
}