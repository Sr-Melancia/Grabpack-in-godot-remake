extends StaticBody3D

@onready var light = $OmniLight3D
@onready var puzzle_complete = $puzzle_complete
@onready var recieved = $recieved
@onready var disable = $disable
@onready var energy_timer = $"Energy timer"

@export_category("Settings")
##If enabled, it plays the puzzle complete sound when powered
@export var play_complete_sound = false
@export var power_time = 8.0
@export var ultra_light = false

var powered = false

signal power_recieved
signal unpowered

func _ready() -> void:
	energy_timer.wait_time = power_time

func _power():
	$Energy.emitting = true
	$"Particle timer".start()
	if not powered:
		emit_signal("power_recieved")
		if play_complete_sound:
			puzzle_complete.play()
		Player.green_powered = false
		recieved.play()
		if not ultra_light:
			light.visible = true
		if ultra_light:
			$"Ultra light".visible = true
		powered = true
		get_tree().call_group("green_puzzle", "_regenerate_power")
		$"Energy timer".start()


func _unpower():
	powered = false
	light.visible = false
	disable.play()
	$"Ultra light".visible = false
	emit_signal("unpowered")

func _on_r_area_entered(area):
	if Player.green_powered:
		_power()


func _on_energy_timer_timeout() -> void:
	_unpower()


func _on_particle_timer_timeout() -> void:
	$Energy.emitting = false
