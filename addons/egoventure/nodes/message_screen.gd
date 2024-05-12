# A message screen shown when when a game is loaded/saved
extends CanvasLayer


# Hide the screen as default
func _ready():
	$Screen.hide()
	$DebugScreen.hide()
	$Screen.theme = EgoVenture.configuration.design_theme
	$DebugScreen.theme = EgoVenture.configuration.design_theme
	
	# Add margin on top for inventory box
	$Screen/Margin.margin_top = EgoVenture.configuration.inventory_size
	
	# Set theme overrides for message
	$Screen/Panel.add_stylebox_override(
		"panel",
		$Screen/Panel.get_stylebox(
			"message_screen",
			"Panel"
		)
	)
	$Screen/Margin/Message.add_font_override(
		"font",
		$Screen/Margin/Message.get_font(
			"message_screen", 
			"Label"
		)
	)
	$Screen/Margin/Message.add_color_override(
		"font_color",
		$Screen/Margin/Message.get_color(
			"message_screen_font_color", 
			"Label"
		)
	)
	
	# Set theme overrides for debug message
	$DebugScreen/DebugMargin/DebugMessage.add_font_override(
		"font",
		$DebugScreen/DebugMargin/DebugMessage.get_font(
			"debug_message", 
			"Label"
		)
	)
	$DebugScreen/DebugMargin/DebugMessage.add_color_override(
		"font_color",
		$DebugScreen/DebugMargin/DebugMessage.get_color(
			"debug_message_font_color", 
			"Label"
		)
	)
	
	# Set margin of messages to 2% of window size
	var margin_value_x = int(ProjectSettings.get("display/window/size/width") / 50)
	var margin_value_y = int(ProjectSettings.get("display/window/size/height") / 50)
	$Screen/Margin.add_constant_override("margin_top", margin_value_y)
	$Screen/Margin.add_constant_override("margin_left", margin_value_x)
	$Screen/Margin.add_constant_override("margin_bottom", margin_value_y)
	$Screen/Margin.add_constant_override("margin_right", margin_value_x)
	$DebugScreen/DebugMargin.add_constant_override("margin_top", margin_value_y)
	$DebugScreen/DebugMargin.add_constant_override("margin_left", margin_value_x)
	$DebugScreen/DebugMargin.add_constant_override("margin_bottom", margin_value_y)
	$DebugScreen/DebugMargin.add_constant_override("margin_right", margin_value_x)
	
	# Set alignment of message
	var align_h = EgoVenture.configuration.menu_message_align_horizontal
	var align_v = EgoVenture.configuration.menu_message_align_vertical
	
	if align_h == 0:
		$Screen/Margin/Message.set_h_size_flags(Control.SIZE_FILL)
	elif align_h == 1:
		$Screen/Margin/Message.set_h_size_flags(Control.SIZE_SHRINK_CENTER)
	else:
		$Screen/Margin/Message.set_h_size_flags(Control.SIZE_SHRINK_END)
	if align_v == 0:
		$Screen/Margin/Message.set_v_size_flags(Control.SIZE_FILL)
	elif align_v == 1:
		$Screen/Margin/Message.set_v_size_flags(Control.SIZE_SHRINK_CENTER)
	else:
		$Screen/Margin/Message.set_v_size_flags(Control.SIZE_SHRINK_END)
	
	# Set alignment of debug message
	align_h = EgoVenture.configuration.debug_message_align_horizontal
	align_v = EgoVenture.configuration.debug_message_align_vertical
	
	if align_h == 0:
		$DebugScreen/DebugMargin/DebugMessage.set_h_size_flags(Control.SIZE_FILL)
	elif align_h == 1:
		$DebugScreen/DebugMargin/DebugMessage.set_h_size_flags(Control.SIZE_SHRINK_CENTER)
	else:
		$DebugScreen/DebugMargin/DebugMessage.set_h_size_flags(Control.SIZE_SHRINK_END)
	if align_v == 0:
		$DebugScreen/DebugMargin/DebugMessage.set_v_size_flags(Control.SIZE_FILL)
	elif align_v == 1:
		$DebugScreen/DebugMargin/DebugMessage.set_v_size_flags(Control.SIZE_SHRINK_CENTER)
	else:
		$DebugScreen/DebugMargin/DebugMessage.set_v_size_flags(Control.SIZE_SHRINK_END)
	
	# Display debug message when it's enabled in configuration and it's a debug build
	if OS.is_debug_build() and EgoVenture.configuration.debug_display_scene_path:
		$DebugScreen.show()


func _process(_delta):
	# Update current scene name in debug message when visible
	if $DebugScreen.visible:
		$DebugScreen/DebugMargin/DebugMessage.text = \
			EgoVenture.current_scene.get_file().get_basename()


# Display a message for a time set in game configuration (used for load/save game message)
#
# ** Arguments **
#
# - text: message text to be displayed
func show_message(text: String):
	if text != "":
		$Screen/Margin/Message.text = tr(text)
		$Animation.play("message", -1, 1 / EgoVenture.configuration.menu_message_duration_seconds)
		$Screen.show()


func _on_Animation_animation_finished(_anim_name):
	$Screen.hide()
