extends Area2D

var isMouseIn := false
var isPressed := false
var conNode : int
var conRight : bool
var isLocked = false

func _ready() -> void:
	get_viewport().physics_object_picking_first_only = false
	mouse_entered.connect(func(): print("MOUSE ENTERED"))
	mouse_exited.connect(func(): print("MOUSE EXITED"))
	
func _physics_process(delta: float) -> void:
	if not isLocked:
		if Input.is_action_pressed("click") and isMouseIn and not Global.isHeld:
			isPressed = true
			Global.heldWire = self
			Global.isHeld = true
		elif Global.heldWire == self:
			pass
		else:
			isPressed = false
	
		if isPressed == true:
			global_position =  get_global_mouse_position()
	
	else:
		pass

func lockPlug(plug) -> void:
	plug.remove_from_group("Slots")
	Global.plugSlots = get_tree().get_nodes_in_group("Slots")
	var shiftPos = plug.global_position + Vector2(7,0)
	global_position = shiftPos
	conNode = plug.nodeNum
	conRight = plug.isRight
	isLocked = true
	#print("Locking Node: %s" % self)
	pass
	
func checkPlug() -> void:
	for s in Global.plugSlots:
		var shiftPos = s.global_position + Vector2(7,0)
		var dis = global_position.distance_squared_to(shiftPos)
		if dis < 15:
			lockPlug(s)

func _on_mouse_entered() -> void:
	print("ENTER")
	isMouseIn = true

func _on_mouse_exited() -> void:
	print("EXIT")
	if !isPressed:
		isMouseIn = false


func _unhandled_input(event):
	if event.is_action("click"):
		if event.is_action_released("click") and not event.is_echo():
			Global.heldWire = null
			Global.isHeld = false
			isMouseIn = false
			checkPlug()
