extends Node2D

@export var background_controller: BackgroundController
@export var tile_colors: Array[TileColor]
@export var tile_scene: PackedScene
@export var tile_size: float = 64.0
@export var preset_items: Array[PresetItem]

var current_state: int = 1
var tiles: Array = []
var item_instances: Array[Node2D] = []

var board_layout = [
	[0, 1, 1, 0, 9],
	[0, 3, 2, 9, 3],
	[9, 3, 1, 0, 2],
	[2, 1, 2, 1, 9],
	[1, 3, 9, 0, 9]
]

func get_state() -> int:
	return current_state

func get_items() -> Array:
	var items = []
	for item in preset_items:
		items.append(item.visible)
	return items

func restore_state(state: int, items: Array):
	change_state(state, true)

	for i in range(preset_items.size()):
		preset_items[i].visible = items[i]
		item_instances[i].visible = items[i]

func _ready():
	build_board()
	initialize_items()
	change_state(current_state)

func build_board():
	var rows = board_layout.size()
	var columns = board_layout[0].size()
	var offset = Vector2(columns - 1, rows - 1) * tile_size / 2

	for y in range(rows):
		for x in range(columns):
			var type = board_layout[y][x]
			if type == 9:
				continue

			var tile = tile_scene.instantiate()
			tile.tile_type = type
			tile.tile_colors = tile_colors
			tile.position = Vector2(x, y) * tile_size - offset
			tile.tile_size = tile_size * 0.9
			add_child(tile)
			tiles.append(tile)

func initialize_items():
	item_instances.clear()

	for i in range(preset_items.size()):
		preset_items[i] = preset_items[i].duplicate()
		var item = preset_items[i]

		var instance = item.item_scene.instantiate()
		instance.position = grid_to_world(item.position)
		add_child(instance)
		instance.visible = item.visible
		item_instances.append(instance)

func can_move_to(grid_position: Vector2i, player: PlayerController):
	for item in preset_items:
		if item.position == grid_position:
			if "door1" in item.item_name:
				if "key1" in player.get_collected_items():
					return true
				return false
			return true
	return true

func step_onto(grid_position: Vector2i, player: PlayerController):
	for i in range(preset_items.size()):
		var item = preset_items[i]

		if item.position != grid_position or not item.collectable or not item.visible:
			continue

		player.get_collectable(item)
		item.visible = false
		item_instances[i].visible = item.visible
		

func get_tile_at(grid_position: Vector2i):
	var index = 0

	for y in range(board_layout.size()):
		for x in range(board_layout[y].size()):
			if board_layout[y][x] == 9:
				continue

			if Vector2i(x, y) == grid_position:
				return tiles[index]

			index += 1

	return null

func grid_to_world(grid_position: Vector2i) -> Vector2:
	var rows = board_layout.size()
	var columns = board_layout[0].size()
	var offset = Vector2(columns - 1, rows - 1) * tile_size / 2

	return Vector2(grid_position) * tile_size - offset

func change_state(new_state: int, instant: bool = false):
	current_state = new_state
	background_controller.change_color(tile_colors[new_state].foreground, instant)

	for tile in tiles:
		tile.onChangeToState(current_state)
