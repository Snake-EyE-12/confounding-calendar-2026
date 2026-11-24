
extends Area2D

var isMouseIn := false
var isPressed := false
var conNode: int
var conRight: bool
var isLocked := false

func _ready() -> void:
	get_viewport().physics_object_picking = true
	get_viewport().physics_object_picking_first_only = false

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _physics_process(delta: float) -> void:
	if isLocked:
		return

	if Input.is_action_pressed("click") and isMouseIn and not Global.isHeld:
		isPressed = true
		Global.heldWire = self
		Global.isHeld = true
	elif Global.heldWire != self:
		isPressed = false

	if isPressed:
		global_position = get_global_mouse_position()

func lockPlug(plug) -> void:
	Global.plugSlots.erase(plug)

	var shiftPos = plug.global_position + Vector2(7, 0)
	global_position = shiftPos
	conNode = plug.nodeNum
	conRight = plug.isRight
	isLocked = true

func checkPlug() -> void:
	for s in Global.plugSlots:
		var shiftPos = s.global_position + Vector2(7, 0)
		var dis = global_position.distance_squared_to(shiftPos)

		if dis < 15:
			lockPlug(s)
			return

func _on_mouse_entered() -> void:
	isMouseIn = true

func _on_mouse_exited() -> void:
	if not isPressed:
		isMouseIn = false

func _unhandled_input(event):
	if event.is_action_released("click") and not event.is_echo():
		Global.heldWire = null
		Global.isHeld = false
		checkPlug()
