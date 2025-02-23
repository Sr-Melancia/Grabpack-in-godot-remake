extends Node3D

func _on_grabpack_item_collected() -> void:
	$"Gates doors/Large Gate".call("_open")


func _on_battery_socket_battery_placed() -> void:
	$"Gates doors/Gate".call("_open")


func _on_flammable_object_burned() -> void:
	$"Gates doors/Door".locked = false
	$"Gates doors/Door"._unlock()


func _on_door_locked_attemp() -> void:
	Game.tooltip("flammable objects can be burned with flare gun, try it", 6)

var green_socket1 = false
var green_socket2 = false

func _on_battery_socket_3_battery_placed() -> void:
	green_socket2 = true
	if green_socket1 and green_socket2: $Puzzle/green_source._regenerate_power()

func _on_battery_socket_2_battery_placed() -> void:
	green_socket1 = true
	if green_socket1 and green_socket2: $Puzzle/green_source._regenerate_power()


func _on_purple_panel_jumped() -> void:
	$Player._block_hand()


func _on_blue_scanner_scan_complete() -> void:
	$Player._enable_hand()
	$Player._lower_grabpack()


func _on_collectable_hand_collected() -> void:
	Game.tooltip("press 1 to switch hand", 5)
	$Player._switch_hand(1)
	$Player.hand_changer._red()


func _on_green_source_power_given() -> void:
	$Player._power_green_line()


func _on_green_reciever_power_recieved() -> void:
	$Player._unpower_green_line()
	$"wire/Wire fragment"._power()


func _on_wire_fragment_4_finished_powering() -> void:
	$"Puzzle/Blue Scanner".powered = true


func _on_no_grabpack_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"): $Player._lower_grabpack()


func _on_no_grabpack_area_area_exited(area: Area3D) -> void:
	if area.is_in_group("player"): $Player._raise_grabpack()
