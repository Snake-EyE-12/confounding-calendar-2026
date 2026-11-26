class_name BackgroundController
extends Control

@export var animation_duration: float = 0.4
@export var current_background: ColorRect
@export var background_circle: PackedScene

var current_tweens: Array[Tween] = []

func _ready():
	current_background.color = Color("#f8e5d7")


func change_color(color: Color, instant: bool = false):
	if instant:
		for tween in current_tweens:
			if tween and tween.is_running():
				tween.kill()

		current_tweens.clear()

		for child in get_children():
			if child is ColorRect and child != current_background:
				child.queue_free()

		current_background.color = color
		return

	Global.audio_player.play_state_change()
	var circle = background_circle.instantiate()
	add_child(circle)

	circle.play(color, animation_duration, func():
		current_background.color = color
		circle.queue_free()
	)
