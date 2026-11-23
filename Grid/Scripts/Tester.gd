
extends Node

@export var board_controller: Node
@export var player: Node

func _process(_delta):
	if Input.is_key_pressed(KEY_1):
		board_controller.change_state(1)
	elif Input.is_key_pressed(KEY_2):
		board_controller.change_state(2)
	elif Input.is_key_pressed(KEY_3):
		board_controller.change_state(3)
	elif Input.is_key_pressed(KEY_SPACE):
		player.check_walkable()
	elif Input.is_key_pressed(KEY_W) or Input.is_action_just_pressed("ui_up"):
		player.move(Vector2i.UP)
	elif Input.is_key_pressed(KEY_S) or Input.is_action_just_pressed("ui_down"):
		player.move(Vector2i.DOWN)
	elif Input.is_key_pressed(KEY_A) or Input.is_action_just_pressed("ui_left"):
		player.move(Vector2i.LEFT)
	elif Input.is_key_pressed(KEY_D) or Input.is_action_just_pressed("ui_right"):
		player.move(Vector2i.RIGHT)
