extends Node3D

@export var locked = false

func _ready() -> void:
	if locked: _lock()
	if not locked: _interactable()

func _interactable():
	$Locked_group.visible =false
	$E.visible = true
	$Unlocked_group.visible = false


func _lock():
	$Locked_group.visible = true
	$E.visible = false
	$Unlocked_group.visible = false

func _got_key():
	$Locked_group.visible = false
	$Unlocked_group.visible = true
	$E.visible = false
