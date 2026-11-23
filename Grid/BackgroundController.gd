
class_name BackgroundController
extends Control

@export var animation_duration: float = 0.4

@export var current_background: ColorRect
@export var transition_background: ColorRect
# working

var current_tween: Tween

func _ready():
	var shader = Shader.new()
	shader.code = """
shader_type canvas_item;

uniform float radius = 0.0;

void fragment() {
	float distance_from_center = length(UV - vec2(0.5));
	float alpha = 1.0 - smoothstep(radius - 0.005, radius, distance_from_center);
	COLOR = vec4(COLOR.rgb, alpha);
}
"""
	var material = ShaderMaterial.new()
	material.shader = shader

	transition_background.material = material
	transition_background.color = Color.WHITE
	transition_background.material.set_shader_parameter("radius", 0.0)
	transition_background.visible = false

func change_color(color: Color, instant: bool = false):
	if current_tween:
		current_tween.kill()

	if instant:
		current_background.color = color
		transition_background.visible = false
		return

	transition_background.color = color
	transition_background.visible = true
	transition_background.material.set_shader_parameter("radius", 0.0)

	current_tween = create_tween()
	current_tween.tween_method(
		func(value): transition_background.material.set_shader_parameter("radius", value),
		0.0, 1.0, animation_duration
	)

	current_tween.tween_callback(func():
		current_background.color = color
		transition_background.visible = false
	)
