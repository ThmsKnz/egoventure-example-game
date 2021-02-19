extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_right_pressed():
	MdnaCore.change_scene("res://scenes/room1f.tscn")


func _on_left_pressed():
	MdnaCore.change_scene("res://scenes/room1b.tscn")




func _on_TriggerHotspot_item_used(item: InventoryItem):
	if item.title == "Keys":
		Parrot.play(preload("res://dialogs/keys.tres"))
	elif item.title == "screwdriver":
		Boombox.play_effect(preload("res://sounds/cheers.ogg"))
