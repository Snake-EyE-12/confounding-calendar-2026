extends ColorRect

const CIRCLE_SHADER = """
shader_type canvas_item;

uniform float radius = 0.0;

void fragment() {
	float distance_from_center = length(UV - vec2(0.5));
	float alpha = 1.0 - smoothstep(radius - 0.005, radius, distance_from_center);
	COLOR = vec4(COLOR.rgb, alpha);
}
"""

var tween: Tween

func play(color: Color, duration: float, on_complete: Callable):
	self.color = color
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var shader = Shader.new()
	shader.code = CIRCLE_SHADER

	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("radius", 0.0)
	self.material = material

	tween = create_tween()
	tween.tween_method(
		func(value): material.set_shader_parameter("radius", value),
		0.0, 1.0, duration
	)
	tween.tween_callback(on_complete)
