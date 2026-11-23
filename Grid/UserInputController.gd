extends Node

@export var undo_controller: Node

func _input(event):
	if not event is InputEventKey or not event.pressed or event.is_echo():
		return

	match event.keycode:
		KEY_1:
			undo_controller.change_board_state(1)
		KEY_2:
			undo_controller.change_board_state(2)
		KEY_3:
			undo_controller.change_board_state(3)
		KEY_W, KEY_UP:
			undo_controller.move_player(Vector2i.UP)
		KEY_S, KEY_DOWN:
			undo_controller.move_player(Vector2i.DOWN)
		KEY_A, KEY_LEFT:
			undo_controller.move_player(Vector2i.LEFT)
		KEY_D, KEY_RIGHT:
			undo_controller.move_player(Vector2i.RIGHT)
		KEY_Z:
			undo_controller.undo()
		KEY_R:
			get_tree().reload_current_scene()
