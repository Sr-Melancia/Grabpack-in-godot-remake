extends Node3D

@export_category("Settings")

@export var working = true

signal touched

func _on_det_area_entered(area: Area3D) -> void:
	if Player.r_launched:
		if working:
			emit_signal("touched")
