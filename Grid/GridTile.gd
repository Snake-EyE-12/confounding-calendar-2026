extends Node2D

var tile_colors: Array[TileColor]

@export var tile_size: float = 64.0

var tile_type: int = 0
var is_walkable: bool = true

var fill_color: Color
var border_color: Color

func _ready():
	var colors = tile_colors[tile_type]
	border_color = colors.background
	fill_color = colors.foreground
	queue_redraw()
	

func can_walk() -> bool:
	return is_walkable

func _draw():
	var half = tile_size / 2
	var corner_length = tile_size * 0.2
	var thickness = 3.0

	var rect = Rect2(Vector2(-half, -half), Vector2(tile_size, tile_size))
	draw_rect(rect, fill_color)

	# Top-left
	draw_line(Vector2(-half, -half), Vector2(-half + corner_length, -half), border_color, thickness)
	draw_line(Vector2(-half, -half), Vector2(-half, -half + corner_length), border_color, thickness)

	# Top-right
	draw_line(Vector2(half, -half), Vector2(half - corner_length, -half), border_color, thickness)
	draw_line(Vector2(half, -half), Vector2(half, -half + corner_length), border_color, thickness)

	# Bottom-left
	draw_line(Vector2(-half, half), Vector2(-half + corner_length, half), border_color, thickness)
	draw_line(Vector2(-half, half), Vector2(-half, half - corner_length), border_color, thickness)

	# Bottom-right
	draw_line(Vector2(half, half), Vector2(half - corner_length, half), border_color, thickness)
	draw_line(Vector2(half, half), Vector2(half, half - corner_length), border_color, thickness)

func onChangeToState(new_state: int):
	if tile_type == 0:
		return

	is_walkable = tile_type != new_state
