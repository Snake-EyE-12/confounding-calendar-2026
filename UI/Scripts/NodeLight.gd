extends ColorRect

@export var thisNode : int

func _physics_process(delta: float) -> void:
	#var origin: Vector2 = $DragPlug.global_position
	if Global.curNode == thisNode:
		color = Color.from_string("#f5fbff",Color.BLACK)
	else:
		color = Color.from_string("#0a0a16",Color.BLACK)
