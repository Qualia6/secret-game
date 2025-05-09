shader_type canvas_item;
//render_mode skip_vertex_transform;

uniform sampler2D real_texture;

uniform sampler2D animation;
const int rows = 6;
const int cols = 6;
const float scale_rows = 0.1666666667;
const float scale_cols = 0.1666666667;
uniform int frame_x;
uniform int frame_y;

void vertex() {
	//VERTEX = (MODEL_MATRIX * vec4(VERTEX * 2., 0.0, 1.0)).xy;
}

void fragment() {
	vec2 captured_UV = (UV + vec2(float(frame_x), float(frame_y))) * vec2(scale_rows, scale_cols);
	vec2 offset = texture(animation, captured_UV).xy;
	if (length(offset) < 0.01) discard;

	COLOR = texture(real_texture, offset);
}