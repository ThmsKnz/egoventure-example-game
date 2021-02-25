extends Node2D


func _ready():
	MdnaCore.check_cursor()


func _on_Hotspot_pressed():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_1776_handbag_op.ogg"))
	yield(get_tree().create_timer(0.6), "timeout")
	get_tree().paused = false
	Boombox.ignore_pause = false
	MdnaCore.change_scene("res://scenes/man/man12f_lift1.tscn")



func _on_Hotspot2_pressed():
	Boombox.play_effect(preload("res://sounds/man/man_1776_handbag_back.ogg"))
	MdnaCore.change_scene("res://scenes/man/man12f_op.tscn")

