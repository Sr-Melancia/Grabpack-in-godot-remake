extends Node3D

@export_category("Settings")
@export var needed_hand = 1
@export var scan_time = 2.0
@export var powered = true

@onready var scan_timer = $Scan_time
@onready var scan_sound = $scan
@onready var scan_texture = $Models/Hand/SM_HandScanner_NoWire_mo_WorldGridMaterial_0_Material_002_0
@onready var hand_position = $Marker

var scanned = false
var scanning = false

func _ready() -> void:
	scan_timer.wait_time = scan_time

func _on_hand_det_area_entered(area: Area3D) -> void:
	if Player.r_launched and Player.current_hand == needed_hand:
		_scan()
		_grab()
	if not Player.r_launched and scanning:
		_cancel_scan()

func _grab():
	get_tree().call_group("player", "_set_retract_mode_r", false)
	get_tree().call_group("player", "_update_r_anim", "grab_coil")
	get_tree().call_group("player", "_update_r_position", hand_position.global_position, hand_position.global_rotation)

func _cancel_scan():
	scanning = false
	scan_sound.stop()
	scan_timer.stop()

func _scan():
	scan_timer.start()
	scan_sound.play()


func _on_scan_finished() -> void:
	if scanning:
		scanning = false
		scan_sound.stop()
		scan_sound.stop()


func _on_scan_time_timeout() -> void:
	scanning = false
	scanned = true
	$"Scan complete".play()
	get_tree().call_group("player", "_retract_hands")
