# The configuration of an MDNA game base don MDNA core
tool
class_name GameConfiguration
extends Resource


# The theme holding all design configurations
var design_theme: Theme

# The game's logo
var design_logo: Texture

# Cursors
var design_cursors: Array

# The menu background texture
var menu_background: Texture

# The music playing when the menu is opened
var menu_music: AudioStream

# A sound effect to play when the something is pressed
var menu_switch_effect: AudioStream

# A sound effect played when the mouse is over the menu button
var menu_button_effect_hover: AudioStream

# A sound effect played when the a menu button is clicked
var menu_button_effect_click: AudioStream

# The main menu item separation
var menu_item_separation: int = 30

# The background texture for the save slots
var menu_saveslots_background: Texture

# The image for the "Previous page" button
var menu_saveslots_previous_image: Texture

# The image for the "Next page" button
var menu_saveslots_next_image: Texture

# The color used for empty save slots
var menu_saveslots_empty_color: Color = Color(0, 0, 0, 0.55)

# The text shown under the free save slot
var menu_saveslots_free_text: String = "SAVESLOTS_FREE"

# Orientation of save slot page indicator
var menu_saveslots_page_label_alignment: int = 0

# The background of the options menu
var menu_options_background: Texture

# The sample to play when the speech slider is changed
var menu_options_speech_sample: AudioStream

# The sample to play when the effect slider is changed
var menu_options_effects_sample: AudioStream

# The modulate color for selected locale flags
var menu_options_locale_button_modulate: Color = Color(1, 1, 1, .2)

# The modulate color for selected locale flags
var menu_options_locale_button_modulate_selected: Color = Color(1, 1, 1)

# Hide the language selection from the options menu
var menu_options_hide_language_selection: bool = false

# The confirmation text for the quit confirmation prompt
var menu_quit_confirmation: String = "DIALOG_QUIT"

# The confirmation text for the overwrite confirmation prompt
var menu_overwrite_confirmation: String = "DIALOG_OVERWRITE"

# The confirmation text for the restart confirmation prompt
var menu_restart_confirmation: String = "DIALOG_RESTART"

# Notification message when game has been loaded
var menu_message_load: String = ""

# Notification message when game has been saved
var menu_message_save: String = "MESSAGE_SAVE"

# Horizontal alignment of message
var menu_message_align_horizontal: int = 1

# Vertical alignment of message
var menu_message_align_vertical: int = 2

# Duration of message display in seconds
var menu_message_duration_seconds: float = 1.0

# The vertical size of the inventory bar
var inventory_size: int = 92

# The texture for the menu button (on touch devices)
var inventory_texture_menu: Texture

# The texture for the notepad button
var inventory_texture_notepad: Texture

# The texture for the hot spots reveal button (on touch devices)
var inventory_texture_reveal: Texture

# The texture for the left arrow of the inventory bar
var inventory_texture_left_arrow: Texture

# The texture for the right arrow of the inventory bar
var inventory_texture_right_arrow: Texture

# The path to the hints csv file
var notepad_hints_file: String

# The texture in the notepad screen
var notepad_background: Texture

# The notepad goals label rect
var notepad_goals_rect: Rect2

# The notepad hints label rect
var notepad_hints_rect: Rect2

# The flashing map image
var tools_map_image: Texture

# The sound to play when flashing the map
var tools_map_sound: AudioStream

# How wide the left and right navigation areas should be in the
# four room scene
var tools_navigation_width: float

# The stretch ratio that influences the height of the subtitle panel. The bigger 
# this value, the smaller the subtitle panel.
var tools_dialog_stretch_ratio: float = 2.0

# The number of seconds to fade between the two music channels
var tools_music_fader_seconds: float = 0.5

# The number of seconds to fade between the two background channels
var tools_background_fader_seconds: float = 0.5

# The path where the scenes are stored
var cache_scene_path: String = "res://scenes"

# Number of scenes to precache before and after the current scene
var cache_scene_count: int = 2

# Size of scene cache in MB
var cache_maximum_size_megabyte: int = 50

# A list of scenes (as path to the scene files) that are always cached
var cache_permanent: PoolStringArray = []

# The minimum time to show the loading indicator when precaching
var cache_minimum_wait_seconds: int = 4

# Whether the minimum wait time can be skipped by left clicking
var cache_minimum_wait_skippable: bool = false

# Display scene path name in game (only in debug build)
var debug_display_scene_path: bool = false

# Horizontal alignment of debug message
var debug_message_align_horizontal: int = 2

# Vertical alignment of debug message
var debug_message_align_vertical: int = 2


# Build the property list
func _get_property_list():
	var properties = []
	properties.append({
		name = "Design",
		type = TYPE_NIL,
		hint_string = "design_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "design_theme",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Theme"
	})
	properties.append({
		name = "design_logo",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "design_cursors",
		type = TYPE_ARRAY,
		hint = 24,
		hint_string = "17/17:Resource"
	})
	properties.append({
		name = "Menu",
		type = TYPE_NIL,
		hint_string = "menu_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "menu_background",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "menu_music",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	properties.append({
		name = "menu_switch_effect",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	properties.append({
		name = "menu_button_effect_hover",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	properties.append({
		name = "menu_button_effect_click",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	properties.append({
		name = "menu_item_separation",
		type = TYPE_INT
	})
	properties.append({
		name = "menu_quit_confirmation",
		type = TYPE_STRING
	})
	properties.append({
		name = "menu_overwrite_confirmation",
		type = TYPE_STRING
	})
	properties.append({
		name = "menu_restart_confirmation",
		type = TYPE_STRING
	})
	properties.append({
		name = "menu_message_load",
		type = TYPE_STRING
	})	
	properties.append({
		name = "menu_message_save",
		type = TYPE_STRING
	})
	properties.append({
		name = "menu_message_align_horizontal",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = "Left,Center,Right"
	})
	properties.append({
		name = "menu_message_align_vertical",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = "Top,Center,Bottom"
	})
	properties.append({
		name = "menu_message_duration_seconds",
		type = TYPE_REAL
	})
	properties.append({
		name = "Saveslots",
		type = TYPE_NIL,
		hint_string = "menu_saveslots",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "menu_saveslots_background",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "menu_saveslots_previous_image",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "menu_saveslots_next_image",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "menu_saveslots_empty_color",
		type = TYPE_COLOR
	})
	properties.append({
		name = "menu_saveslots_free_text",
		type = TYPE_STRING
	})
	properties.append({
		name = "menu_saveslots_page_label_alignment",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = "Left,Center,Right"
	})
	properties.append({
		name = "Inventory",
		type = TYPE_NIL,
		hint_string = "inventory",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		"name": "inventory_size",
		"type": TYPE_INT
	})
	properties.append({
		"name": "inventory_texture_menu",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "Texture"
	})
	properties.append({
		"name": "inventory_texture_notepad",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "Texture"
	})
	properties.append({
		"name": "inventory_texture_reveal",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "Texture"
	})
	properties.append({
		"name": "inventory_texture_left_arrow",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "Texture"
	})
	properties.append({
		"name": "inventory_texture_right_arrow",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "Texture"
	})
	properties.append({
		name = "Options",
		type = TYPE_NIL,
		hint_string = "menu_options",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "menu_options_background",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "menu_options_speech_sample",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	properties.append({
		name = "menu_options_effects_sample",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	properties.append({
		name = "menu_options_locale_button_modulate",
		type = TYPE_COLOR
	})
	properties.append({
		name = "menu_options_locale_button_modulate_selected",
		type = TYPE_COLOR
	})
	properties.append({
		name = "menu_options_hide_language_selection",
		type = TYPE_BOOL
	})
	properties.append({
		name = "Notepad",
		type = TYPE_NIL,
		hint_string = "notepad",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "notepad_hints_file",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_FILE,
		hint_string = "*.txt"
	})
	properties.append({
		name = "notepad_background",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "notepad_goals_rect",
		type = TYPE_RECT2
	})
	properties.append({
		name = "notepad_hints_rect",
		type = TYPE_RECT2
	})
	properties.append({
		name = "Tools",
		type = TYPE_NIL,
		hint_string = "tools_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "tools_map_image",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "tools_map_sound",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	properties.append({
		name = "tools_navigation_width",
		type = TYPE_REAL
	})
	properties.append({
		name = "tools_dialog_stretch_ratio",
		type = TYPE_REAL
	})
	properties.append({
		name = "tools_music_fader_seconds",
		type = TYPE_REAL
	})
	properties.append({
		name = "tools_background_fader_seconds",
		type = TYPE_REAL
	})
	properties.append({
		name = "Cache",
		type = TYPE_NIL,
		hint_string = "cache_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "cache_scene_path",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_DIR
	})
	properties.append({
		name = "cache_scene_count",
		type = TYPE_INT
	})
	properties.append({
		name = "cache_maximum_size_megabyte",
		type = TYPE_INT
	})
	properties.append({
		name = "cache_permanent",
		type = TYPE_STRING_ARRAY,
	})
	properties.append({
		name = "cache_minimum_wait_seconds",
		type = TYPE_INT,
	})
	properties.append({
		name = "cache_minimum_wait_skippable",
		type = TYPE_BOOL,
	})
	properties.append({
		name = "Debug",
		type = TYPE_NIL,
		hint_string = "debug_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "debug_display_scene_path",
		type = TYPE_BOOL,
	})
	properties.append({
		name = "debug_message_align_horizontal",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = "Left,Center,Right"
	})
	properties.append({
		name = "debug_message_align_vertical",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = "Top,Center,Bottom"
	})
	return properties
