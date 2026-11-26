
extends Node
class_name UndoController

@export var board_controller: Node
@export var player: Node
@export var tape: TapeController

var snapshots: Array = []

func _ready() -> void:
	Global.connection_made.connect(on_wire_connected)
	tape.tape_advancing.connect(on_advance_tape)

func on_wire_connected():
	save_snapshot()
	
func on_advance_tape():
	save_snapshot()

func move_tape():
	
	var result = tape.advance()
	if result == -1:
		print("Tape did not move")
	else:
		change_board_state(result + 1)
	

func change_board_state(state: int):
	if state == board_controller.current_state:
		return

	#save_snapshot()
	board_controller.change_state(state)
	player.check_walkable()

func move_player(direction: Vector2i):
	if player.is_moving or player.is_dead or "goal" in player.get_collected_items():
		return

	var target = player.grid_position + direction
	if board_controller.get_tile_at(target) == null:
		return

	save_snapshot()
	player.move(direction)

func check_player_walkable():
	if player.is_dead:
		return

	save_snapshot()
	player.check_walkable()

func save_snapshot():
	var snapshot = {
		"board_state": board_controller.get_state(),
		"board_items": board_controller.get_items(),
		"player_position": player.grid_position,
		"player_dead": player.is_dead,
		"collectables": player.get_collected_items().duplicate(),
		"tape_state": tape.get_state()
	}

	snapshots.append(snapshot)

func undo():
	if snapshots.is_empty():
		return

	if player.is_moving:
		return

	var snapshot = snapshots.pop_back()

	board_controller.restore_state(snapshot.board_state, snapshot.board_items)
	player.restore_state(snapshot.player_position, snapshot.player_dead, snapshot.collectables)
	tape.restore_state(snapshot.tape_state)

	print("Undo: ", snapshots.size(), " snapshots remaining")
