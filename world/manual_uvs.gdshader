shader_type canvas_item;

uniform mat2 t;

void vertex() {
	UV = t * UV;
}
