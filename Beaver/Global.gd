extends Control

signal connection_made

@export var isHeld := false
@export var heldWire : Node
@export var plugSlots := Array()
@export var plugs := Array()
@export var curNode : int = 1


var audio_player: AudioPlayer:
	get:
		return get_tree().current_scene.get_node_or_null("Game/Audio") as AudioPlayer




func _ready() -> void:
	get_viewport().physics_object_picking = true
	get_viewport().physics_object_picking_first_only = false

func initialize():
	plugSlots = get_tree().get_nodes_in_group("Slots")
	plugs = get_tree().get_nodes_in_group("Plug")


# UNDO SYSTEM

func get_state() -> Dictionary:
	var plugStates = []

	for p in get_tree().get_nodes_in_group("Plug"):
		var dragPlug = p.dragPlug

		plugStates.append({
			"plug": p,
			"position": dragPlug.global_position,
			"isLocked": dragPlug.isLocked,
			"conNode": dragPlug.conNode,
			"conRight": dragPlug.conRight
		})

	return {
		"curNode": curNode,
		"plugs": plugStates,
		"plugSlots": plugSlots.duplicate()
	}


func restore_state(state: Dictionary) -> void:
	curNode = state["curNode"]

	for plugState in state["plugs"]:
		var p = plugState["plug"]

		if not is_instance_valid(p):
			continue

		var dragPlug = p.dragPlug

		dragPlug.global_position = plugState["position"]
		dragPlug.isLocked = plugState["isLocked"]
		dragPlug.conNode = plugState["conNode"]
		dragPlug.conRight = plugState["conRight"]
		dragPlug.resetInteraction()

	isHeld = false
	heldWire = null

	plugs = get_tree().get_nodes_in_group("Plug")
	plugSlots = state["plugSlots"].duplicate()
