extends Control

func _ready():
	MdnaInventory.disable()
	Boombox.play_music(preload("res://music/intro.ogg"))
	MainMenu.saveable = true

func to_1():
	MdnaCore.change_scene("res://scenes/room1f.tscn")
