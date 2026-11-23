extends Node2D

@export var color : Color
@export var state : int
@export var linkNode : int
@onready var PlugStartPos : Vector2 = $DragPlug/CollisionShape2D.global_position
@onready var Line := $LineMain

func _ready() -> void:
	Line.default_color = color
	$DragPlug/CollisionShape2D.debug_color = color
	var ParName = name
	if ParName == "LineStart":
		#$DragPlug.global_position = Vector2(45,234)
		makeHangLine()
		$DragPlug.lockPlug($"../LeftPanel/Node1Left/Plug3")
	pass

func _physics_process(delta: float) -> void:
	#var origin: Vector2 = $DragPlug.global_position
	if $DragPlug.isPressed:
		makeHangLine()
		#setUpLinearLine()
	elif $DragPlug.position != PlugStartPos:
		makeHangLine()
		returnPos()
	else:
		Line.clear_points()

func makeHangLine() -> void:
	Line.clear_points()
	var curve := Curve2D.new()

	#adjustment vector
	var xAdj : float = abs($DragPlug/CollisionShape2D.global_position.x - PlugStartPos.x)
	var yAdj := .5*xAdj
	var AdjVec := Vector2(xAdj/2,yAdj)
	
	#Shadow Curve
	curve.add_point(PlugStartPos, AdjVec)
	curve.add_point($DragPlug/CollisionShape2D.global_position-Vector2(5, 0), AdjVec )
	var ArrayCurvedPoints :PackedVector2Array = curve.get_baked_points()
	for point in ArrayCurvedPoints:
		Line.add_point(point)

func setUpLinearLine() -> void:
	Line.clear_points()
	Line.add_point(PlugStartPos)
	Line.add_point($DragPlug/CollisionShape2D.global_position-Vector2(5, 0) )

func returnPos() -> void:
	#$DragPlug.position = PlugStartPos
	if not $DragPlug.isLocked:
		$DragPlug.position = lerp( $DragPlug.position , PlugStartPos,.07)
	pass
