# A hotspot that triggers a Parrot dialog for "look" actions
tool
class_name LookHotspot, "res://addons/mdna_core/images/look_hotspot.svg"
extends TextureButton


# The dialog resource that should be played by Parrot
export (String, FILE, "*.tres") var dialog


# Connect to the relevant signals and gather the cursors from configuration
func _ready():
	connect("pressed", self, "_on_pressed")
	mouse_default_cursor_shape = Cursors.CURSOR_MAP[Cursors.Type.LOOK]


# The hotspot was clicked, play the dialog
func _gui_input(event):
	if event is InputEventMouseButton and \
			not (event as InputEventMouseButton).pressed:
		if (event as InputEventMouseButton).button_index == BUTTON_LEFT:
			accept_event()
			Parrot.play(load(dialog))
		else:
			MainMenu.toggle()
	
