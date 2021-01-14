# Speedy mouse cursor handling
extends CanvasLayer


# A dictionary of mouse cursor hotspots for cursor shapes
var hotspots: Dictionary

# A dictionary of mouse cursor textures for cursor shapes
var textures: Dictionary

# The current mouse cursors hotspot
var current_hotspot: Vector2

# The current shape
var current_shape


# Activate mouse cursor handling by Speedy and load default cursors
func _init():
	if not Engine.editor_hint:
		Input.set_mouse_mode(
			Input.MOUSE_MODE_HIDDEN
		)
	set_custom_mouse_cursor(
		preload("res://addons/speedy_gonzales/images/arrow.png")
	)


# Switch the cursor texture when needed
func _process(delta):
	if current_shape != Input.get_current_cursor_shape():
		var shape = Input.get_current_cursor_shape()
		current_shape = shape
		current_hotspot = hotspots[shape]
		$Cursor.texture = textures[shape]


# Handle mouse motions
func _input(event):
	if event is InputEventMouseMotion:
		$Cursor.position = event.position - current_hotspot
		

# Set the custom mouse cursor
func set_custom_mouse_cursor(
	image: Texture, 
	shape = Input.CURSOR_ARROW, 
	hotspot: Vector2 = Vector2(0,0)
):
	textures[shape] = image
	hotspots[shape] = hotspot
	if shape == current_shape:
		current_hotspot = hotspots[shape]
		$Cursor.texture = textures[shape]
