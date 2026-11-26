
extends Node2D
class_name PlayerController

@export var board_controller: Node2D
@export var move_duration: float = 0.15

@export var win_text: RichTextLabel

var grid_position: Vector2i = Vector2i(0, 0)
var is_moving: bool = false
var is_dead: bool = false

var collectables = []

func _ready():
	position = board_controller.grid_to_world(grid_position)
	check_walkable()

func move(direction: Vector2i):
	if is_moving or is_dead:
		return

	var target_grid = grid_position + direction
	var can_move_to = board_controller.can_move_to(target_grid, self)
	if not can_move_to:
		return

	var tile = board_controller.get_tile_at(target_grid)
	if tile == null:
		return

	grid_position = target_grid
	is_moving = true
	Global.audio_player.play_move()

	var tween = create_tween()
	tween.tween_property(self, "position", board_controller.grid_to_world(grid_position), move_duration)

	tween.finished.connect(func():
		is_moving = false
		check_walkable()
	)

func get_collectable(item):
	collectables.append(item.item_name)
	if item.item_name.contains("key"):
		Global.audio_player.play_key_pickup()

	if item.item_name == "goal":
		Global.audio_player.play_win()
		win_text.move_to_center()

func restore_state(position: Vector2i, dead: bool, collected_items):
	grid_position = position
	is_dead = dead
	is_moving = false
	collectables = collected_items.duplicate()

	if "goal" not in collected_items:
		win_text.reset_position()

	self.position = board_controller.grid_to_world(grid_position)
	rotation_degrees = 180.0 if dead else 0.0
	modulate = Color.GRAY if dead else Color.WHITE

func check_walkable():
	board_controller.step_onto(grid_position, self)
	var tile = board_controller.get_tile_at(grid_position)
	if tile == null or not tile.can_walk():
		die()

func get_collected_items():
	return collectables.duplicate()

func die():
	if is_dead:
		return

	Global.audio_player.play_lose()
	is_dead = true

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "rotation_degrees", 180.0, 0.3)
	tween.tween_property(self, "modulate", Color.GRAY, 0.3)
