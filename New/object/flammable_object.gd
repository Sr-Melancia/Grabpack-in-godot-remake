extends Node3D

@export_category("Setup")

# can be changed in game
@export var show_hitbox = true
@export var time_until_finish = 2.0

@onready var fire1 = $fire
@onready var fire2 = $fire2
@onready var fire3 = $fire3
@onready var fire4 = $fire4
@onready var flare_ambience = $flare_ambience
@onready var timer = $Timer
@onready var meshs = $mesh


var alreadyburn = false

signal burned

func _ready() -> void:
	timer.wait_time = time_until_finish

func _on_flaredet_area_entered(area):
	if area.is_in_group("flare") and not alreadyburn:
		fire1.emitting = true
		fire2.emitting = true
		fire3.emitting = true
		fire4.emitting = true
		flare_ambience.play()
		timer.start()
		print("burning")
		area.get_parent()._delete_flare()

func _process(delta: float) -> void:
	if show_hitbox:
		$Hitbox.visible = true
	if not show_hitbox:
		$Hitbox.visible = false

func _on_timer_timeout() -> void:
	emit_signal("burned")
	fire1.emitting = false
	fire2.emitting = false
	fire3.emitting = false
	fire4.emitting = false
	flare_ambience.stop()
	$Hitbox.visible = false
	alreadyburn = true
	print("Burned")
	meshs.visible = false
