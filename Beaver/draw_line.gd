
extends Node2D

@export var color: Color
@export var state: int
@export var linkNode: int

@export_group("References")
@export var dragPlug: Area2D
@export var collisionShape: CollisionShape2D
@export var line: Line2D
@export var initialPlug: Node2D

var plugStartPos: Vector2
var dragStartPos: Vector2

func _ready() -> void:
	line.width = 5.0
	
	plugStartPos = collisionShape.global_position
	dragStartPos = dragPlug.position

	line.default_color = color
	collisionShape.debug_color = color

	if initialPlug:
		makeHangLine()
		dragPlug.lockPlug(initialPlug)

func _physics_process(delta: float) -> void:
	if dragPlug.isPressed:
		makeHangLine()
	elif dragPlug.position != dragStartPos:
		makeHangLine()
		returnPos()
	else:
		line.clear_points()

func makeHangLine() -> void:
	line.clear_points()
	var curve := Curve2D.new()

	var start = line.to_local(plugStartPos)
	var end = line.to_local(collisionShape.global_position - Vector2(1, 0))

	var xAdj: float = abs(end.x - start.x)
	var yAdj := .5 * xAdj
	var adjVec := Vector2(xAdj / 2, yAdj)

	curve.add_point(start, adjVec)
	curve.add_point(end, adjVec)

	var curvedPoints: PackedVector2Array = curve.get_baked_points()
	for point in curvedPoints:
		line.add_point(point)

func setUpLinearLine() -> void:
	line.clear_points()
	line.add_point(line.to_local(plugStartPos))
	line.add_point(line.to_local(collisionShape.global_position - Vector2(5, 0)))

func returnPos() -> void:
	if not dragPlug.isLocked:
		dragPlug.position = lerp(dragPlug.position, dragStartPos, .07)
