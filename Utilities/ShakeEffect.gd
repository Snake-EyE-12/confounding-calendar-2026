@tool
extends RichTextEffect
class_name CelebrateEffect

var bbcode = "celebrate"

@export var bounce_height: float = 18.0
@export var horizontal_sway: float = 2.0
@export var speed: float = 10.0
@export var spacing: float = 0.8

func _process_custom_fx(char_fx):
	var phase = char_fx.elapsed_time * speed - char_fx.relative_index * spacing

	var bounce = abs(sin(phase))
	var sway = sin(phase * 0.5)

	char_fx.offset = Vector2(
		sway * horizontal_sway,
		-bounce * bounce_height
	)

	return true
