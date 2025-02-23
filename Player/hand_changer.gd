extends Control

@onready var timer = $visibility

@onready var anim = $AnimationPlayer


func _ready() -> void:
	anim.play_backwards("Fade")

func _flare():
	$Flare.visible = true
	$Purple.visible = false
	$Red.visible = false
	$Green.visible = false
	$Omni.visible = false
	timer.start()
	visible = true
	_open()

func _purple():
	$Flare.visible = false
	$Purple.visible = true
	$Red.visible = false
	$Green.visible = false
	$Omni.visible = false
	timer.start()
	visible = true
	_open()

func _red():
	$Flare.visible = false
	$Purple.visible = false
	$Red.visible = true
	$Green.visible = false
	$Omni.visible = false
	timer.start()
	visible = true
	_open()

func _green():
	$Flare.visible = false
	$Purple.visible = false
	$Red.visible = false
	$Green.visible = true
	$Omni.visible = false
	timer.start()
	visible = true
	_open()

func _dash():
	$Flare.visible = false
	$Purple.visible = false
	$Red.visible = false
	$Green.visible = false
	$Omni.visible = true
	timer.start()
	visible = true
	_open()

func _on_visibility_timeout() -> void:
	anim.play_backwards("Fade")

func _open():
	anim.play("Fade")

func _close():
	anim.play_backwards("Fade")
