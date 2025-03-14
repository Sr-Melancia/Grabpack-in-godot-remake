@tool
extends Node3D

@onready var g1 = $packs/g1
@onready var g2 = $packs/g2

enum pack_types {
	Grabpack_1,
	Grabpack_2
}

@export_category("Settings")
##Which grabpack this collectable grabpack is.
@export var pack: pack_types = pack_types.Grabpack_1
##If enabled, a the collect jingle will play.
@export var play_collect_jingle = false

@onready var jingle = $jingle
@onready var collect = $collect
@onready var get_sfx = $get_sfx

var prev_pack = null
var sel = false

signal collected

func _process(delta):
	if not prev_pack == pack:
		_set_type(pack)
	prev_pack = pack

func _set_type(type):
	g1.visible = false
	g2.visible = false
	if type == 0:
		g1.visible = true
	if type == 1:
		g2.visible = true

func _collect():
	position.y += 400
	visible = false
	emit_signal("collected")
	collect.play()
	jingle.play()
	get_sfx.play()
	if not play_collect_jingle:
		jingle.volume_db = -80

func _on_det_area_entered(area):
	if get_true_collision(area):
		get_tree().call_group("player", "_collect_pack", pack)
		get_tree().call_group("player", "_retract_hands")
		_collect()

func _on_jingle_finished():
	queue_free()

func get_true_collision(area):
	var layer = area.collision_layer
	if layer == 8:
		if Player.l_launched:
			return(true)
		else:
			return(false)
	if layer == 16:
		if Player.r_launched:
			return(true)
		else:
			return(false)

func _input(event):
	if Input.is_action_just_pressed("use"):
		if sel:
			get_tree().call_group("player", "_collect_pack", pack)
			get_tree().call_group("player", "_retract_hands")
			_collect()

@onready var basic_interact = $"Basic interact"

func _on_item_det_area_entered(area):
	sel = true
	basic_interact.visible = true

func _on_item_det_area_exited(area):
	sel = false
	basic_interact.visible = false
