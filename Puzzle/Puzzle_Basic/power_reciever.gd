extends StaticBody3D

@onready var puzzle_complete = $puzzle_complete
@onready var light = $OmniLight3D
@onready var recieved = $recieved

@export_category("Settings")
##The amount of Power Poles needed to power this reciever
@export var required_power_poles = 1
##If enabled, it plays the puzzle complete sound when powered
@export var play_complete_sound = false

signal  power_recieved

var powered = false

func _power():
	if Player.current_powered_poles > required_power_poles - 1:
		emit_signal("power_recieved")
		light.visible = true
		recieved.play()
		powered = true
		get_tree().call_group("player", "_retract_hands")
		if play_complete_sound == true:
			puzzle_complete.play()

func _on_hand_col_area_entered(area):
	if not powered:  
		_grab()
		_power()

func _on_turret_col_area_entered(area):
	if not powered:
		emit_signal("power_recieved")
		light.visible = true
		recieved.play()
		powered = true
		if play_complete_sound == true:
			puzzle_complete.play()

func _grab():
	if Player.r_launched:
		get_tree().call_group("player", '_update_r_position', $Hand_pos.global_position, $Hand_pos.global_rotation)
		get_tree().call_group("player", "_update_r_anim", "grab_coil")
	if Player.l_launched:
		get_tree().call_group("player", '_update_l_position', $Hand_pos.global_position, $Hand_pos.global_rotation)
		get_tree().call_group("player", "_update_l_anim", "grab_coil")
