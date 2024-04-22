extends Node2D

func _on_Hotspot_activate():
	Boombox.ignore_pause = true
	get_tree().paused = true
	Boombox.play_effect(preload("res://sounds/man/man_bedroom_drawer_cl.ogg"))
	await get_tree().create_timer(0.4).timeout
	get_tree().paused = false
	Boombox.ignore_pause = false
	EgoVenture.change_scene_to_file("res://scenes/man/man06b_cl2.tscn")
