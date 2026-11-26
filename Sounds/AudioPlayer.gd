extends Node
class_name AudioPlayer

@export var plug_wire: AudioStreamPlayer2D
@export var machine_activate: AudioStreamPlayer2D
@export var wire_missing: AudioStreamPlayer2D
@export var state_change: AudioStreamPlayer2D
@export var key_pickup: AudioStreamPlayer2D
@export var move: AudioStreamPlayer2D
@export var lose: AudioStreamPlayer2D
@export var win: AudioStreamPlayer2D


func play_plug_wire():
	plug_wire.pitch_scale = randf_range(0.9, 1.1)
	plug_wire.play()
func play_machine_activate():
	machine_activate.pitch_scale = randf_range(0.9, 1.1)
	machine_activate.play()
func play_wire_missing():
	wire_missing.play()
func play_state_change():
	state_change.play()
func play_key_pickup():
	key_pickup.play()
func play_move():
	move.pitch_scale = randf_range(0.9, 1.1)
	move.play()
func play_lose():
	lose.play()
func play_win():
	win.play()
