extends StaticBody3D

@onready var timer = $Timer
@onready var light = $OmniLight3D
@onready var disable = $disable
@onready var recieved = $recieved


@export_category("Settings")
##If enabled, this power source has power. This can be changed during gameplay.
@export var has_power = true
##The amount of time the green hand keeps the power from here before running out.
@export var power_keep_time = 8
##used for bateries power
@export var use_ultra_light = false

var state = true

signal power_given
signal regenerated

func _ready():
	if has_power:
		if use_ultra_light:
			$ultra_light.visible = true
		if not use_ultra_light:
			$OmniLight3D.visible = true
	
	if not has_power:
		_unpower()

func _unpower():
	state = false

func _give_power():
	if state and not Player.green_powered:
		timer.start(power_keep_time)
		state = false
		if not use_ultra_light:
			light.visible = false
		if use_ultra_light:
			$ultra_light.visible = false
		disable.play()
		Player.green_powered = true
		emit_signal("power_given")

func _regenerate_power():
	if not state:
		state = true
		recieved.play()
		if not use_ultra_light:
			light.visible = true
		if use_ultra_light:
			$ultra_light.visible = true
		Player.green_powered = false
		emit_signal("regenerated")

func _on_r_area_entered(area):
	if Player.current_hand == 2:
		_give_power()
func _on_timer_timeout():
	_regenerate_power()
