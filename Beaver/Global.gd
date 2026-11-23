extends Control

@export var isHeld := false
@export var heldWire : Node
@export var plugSlots := Array()
@export var plugs := Array()
@export var curNode : int = 1

func _ready() -> void:
	get_viewport().physics_object_picking = true
	get_viewport().physics_object_picking_first_only = false
	plugSlots = get_tree().get_nodes_in_group("Slots")
	plugs = get_tree().get_nodes_in_group("Plug")
