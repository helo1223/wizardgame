shader_type canvas_item;

uniform vec4 find_color : source_color;
uniform vec4 target_color : source_color;

void fragment() {
	vec4 pixel_color = texture(TEXTURE, UV);
	if (length(pixel_color.rgb - find_color.rgb) < 1.0){
		COLOR *= target_color;
	}
}
