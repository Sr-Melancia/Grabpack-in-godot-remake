extends Node3D

@export_category("Settings")

@export var next_fragment = Node3D
@export var last = false
@export var play_jigle = false

@onready var anim = $AnimationPlayer

@onready var power_time = $Timer

var powered = false
var powering = false

signal finished_powering
signal unpowered

func _ready() -> void:
	anim.play("RESET")

func _power():
	if not powered and not powering:
		anim.play("power")
		power_time.start()
		powering = true


func _on_timer_timeout() -> void:
	if not last:
		next_fragment._power()
	if play_jigle:
		$puzzle_complete.play()
	powering = false
	powered = true
	emit_signal("finished_powering")

var unpowering = false

func _unpower():
	if not unpowering and powered:
		anim.play("unpower")
		unpowering = true
		$Timer2.start()


func _on_timer_2_timeout() -> void:
	powered = false
	unpowering = false
	emit_signal("unpowered")
	if not last:
		next_fragment._unpower()
