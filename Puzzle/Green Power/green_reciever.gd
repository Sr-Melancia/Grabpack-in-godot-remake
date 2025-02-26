extends StaticBody3D

@onready var light = $OmniLight3D
@onready var puzzle_complete = $puzzle_complete
@onready var recieved = $recieved
@onready var disable = $disable
@onready var energy_timer = $"Energy timer"
@onready var disabled_timer = $"Disabled Timer"

@export_category("Settings")
##If enabled, it plays the puzzle complete sound when powered
@export var play_complete_sound = false
@export var power_time = 8.0
@export var ultra_light = false
@export var energy_time = 5.0

var has_power = false
var powered = false

signal power_recieved
signal unpowered
signal hand_repowered

func _ready() -> void:
	energy_timer.wait_time = power_time
	disabled_timer.wait_time = energy_time

func _power():
	$Energy.emitting = true
	$"Particle timer".start()
	has_power = true
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
		$"Energy timer".start()

func _repower_hand():
	has_power = false
	powered = false
	light.visible = false
	disable.play()
	$"Ultra light".visible = false
	emit_signal("hand_repowered")
	Player.green_powered = true

func _unpower():
	get_tree().call_group("green_puzzle", "_regenerate_power")
	has_power = false
	powered = false
	light.visible = false
	disable.play()
	$"Ultra light".visible = false
	emit_signal("unpowered")

var can_grab = false

func _on_r_area_entered(area):
	if Player.green_powered and not has_power:
		_power()
		_grab()
		$cooldown.start()
		can_grab = false
	if not Player.green_powered and has_power and can_grab:
		if Player.current_hand == 2:
			_grab()
			_repower_hand()

@onready var hand_position = $Hand_pos

func _grab():
	get_tree().call_group("player", "_update_r_position", hand_position.global_position, hand_position.global_rotation)
	get_tree().call_group("player", "_update_r_anim", "grab_coil")

func _on_energy_timer_timeout() -> void:
	_unpower()


func _on_particle_timer_timeout() -> void:
	$Energy.emitting = false


func _on_disabled_timer_timeout() -> void:
	_unpower()
	Player.green_powered = false


func _on_cooldown_timeout() -> void:
	can_grab = true
