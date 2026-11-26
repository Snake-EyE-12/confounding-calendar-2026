
extends Control
class_name TapeController

signal tape_advancing

var tape = Array()
var tapePos = 0
var tLength = 31

const TAPE_HEIGHT_RATIO = 0.36
const TAPE_Y_RATIO = 0.58

const ARROW_COLOR = Color("#fd0e45")
const TAPE_BORDER_COLOR = Color("#0a0a16")
const BORDER_WIDTH = 4.0
const DIVIDER_WIDTH = 2.5

const ARROW_WIDTH_RATIO = 0.8
const ARROW_HEIGHT_RATIO = 0.24
const ARROW_GAP_RATIO = 0.07


func _ready() -> void:
	tape.resize(tLength)
	for i in range(tLength):
		tape[i] = 0

	tapePos = 15
	tape[tapePos] = 1

	queue_redraw()


# UNDO SYSTEM

func get_state() -> Dictionary:
	return {
		"tape": tape.duplicate(),
		"tapePos": tapePos,
		"global": Global.get_state()
	}


func save_state() -> Dictionary:
	return get_state()


func restore_state(state: Dictionary) -> void:
	tape = state["tape"].duplicate()
	tapePos = state["tapePos"]

	Global.restore_state(state["global"])

	queue_redraw()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()


func _draw() -> void:
	if size.x <= 0 or size.y <= 0:
		return

	var innerWidth = size.x - BORDER_WIDTH * 2
	var innerHeight = size.y - BORDER_WIDTH * 2
	var cellWidth = innerWidth / tLength

	var tapeHeight = innerHeight * TAPE_HEIGHT_RATIO
	var tapeY = BORDER_WIDTH + innerHeight * TAPE_Y_RATIO

	draw_rect(Rect2(Vector2.ZERO, size), TAPE_BORDER_COLOR, false, BORDER_WIDTH)

	for i in range(tLength):
		var rect = Rect2(
			BORDER_WIDTH + i * cellWidth,
			tapeY,
			cellWidth,
			tapeHeight
		)
		draw_rect(rect, GetStateColor(tape[i]))

	for i in range(1, tLength):
		var x = BORDER_WIDTH + i * cellWidth - DIVIDER_WIDTH / 2
		draw_rect(Rect2(x, tapeY, DIVIDER_WIDTH, tapeHeight), TAPE_BORDER_COLOR)

	draw_rect(
		Rect2(BORDER_WIDTH, tapeY, innerWidth, tapeHeight),
		TAPE_BORDER_COLOR,
		false,
		BORDER_WIDTH
	)

	var arrowWidth = cellWidth * ARROW_WIDTH_RATIO
	var arrowHeight = innerHeight * ARROW_HEIGHT_RATIO
	var arrowCenter = BORDER_WIDTH + (tapePos + 0.5) * cellWidth
	var arrowTop = tapeY - arrowHeight - innerHeight * ARROW_GAP_RATIO

	var arrowPoints = PackedVector2Array([
		Vector2(arrowCenter - arrowWidth * 0.45, arrowTop),
		Vector2(arrowCenter - arrowWidth * 0.45, arrowTop + arrowHeight * 0.4),
		Vector2(arrowCenter - arrowWidth * 0.5, arrowTop + arrowHeight * 0.4),
		Vector2(arrowCenter, arrowTop + arrowHeight),
		Vector2(arrowCenter + arrowWidth * 0.5, arrowTop + arrowHeight * 0.4),
		Vector2(arrowCenter + arrowWidth * 0.45, arrowTop + arrowHeight * 0.4),
		Vector2(arrowCenter + arrowWidth * 0.45, arrowTop)
	])

	draw_colored_polygon(arrowPoints, ARROW_COLOR)


func GetStateColor(state) -> Color:
	if state == 2:
		return Color("#8c0013")
	elif state == 1:
		return Color("#fe5a8f")
	return Color("#f8e5d7")


func moveTapeLeft() -> void:
	tapePos -= 1
	if tapePos < 0:
		tapePos = tLength - 1

	tape[tapePos] = (tape[tapePos] + 1) % 3
	queue_redraw()


func moveTapeRight() -> void:
	tapePos += 1
	if tapePos >= tLength:
		tapePos = 0

	tape[tapePos] = (tape[tapePos] + 1) % 3
	queue_redraw()


func advance() -> int:
	Global.audio_player.play_machine_activate()
	Global.plugs = get_tree().get_nodes_in_group("Plug")

	for p in Global.plugs:
		if p.linkNode != Global.curNode:
			continue

		if p.state != tape[tapePos]:
			continue

		var dragPlug = p.get_node("DragPlug")

		if not dragPlug.isLocked:
			send_missing_wire_blink()
			return -1

		tape_advancing.emit()

		Global.curNode = dragPlug.conNode

		if dragPlug.conRight:
			moveTapeRight()
		else:
			moveTapeLeft()
		return tape[tapePos]

	return -1

func send_missing_wire_blink():
	Global.audio_player.play_wire_missing()
	# Blink for missing wire on activate tape advancement
	pass
