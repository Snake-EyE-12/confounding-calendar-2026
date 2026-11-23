extends RichTextLabel

@export var animation_duration: float = 0.5

var starting_position: Vector2
var starting_scale: Vector2
var current_tween: Tween

func _ready():
	starting_position = position
	starting_scale = scale
	scale = starting_scale * 0.3

func move_to_center():
	if current_tween and current_tween.is_running():
		current_tween.kill()

	var target_position = (get_viewport_rect().size - size) / 2
	current_tween = create_tween()
	current_tween.set_parallel(true)
	current_tween.tween_property(self, "position", target_position, animation_duration)
	current_tween.tween_property(self, "scale", starting_scale, animation_duration)

func reset_position():
	if current_tween and current_tween.is_running():
		current_tween.kill()

	position = starting_position
	scale = starting_scale * 0.3
