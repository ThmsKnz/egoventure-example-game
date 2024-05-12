# A layer that is supposed to grab right mouse button clicks
# to show the menu
extends CanvasLayer


# Set the top margin to under the inventory bar
func set_top(top: float):
	$Control.margin_top = top


# React to mouse button events on the control
func _input(event):
	if Inventory.selected_item == null and \
			not WaitingScreen.is_visible() and \
			not DetailView.is_visible and \
			event.is_action_pressed("ui_menu"):
		if not get_tree().paused and \
			get_viewport().get_mouse_position().y >= $Control.margin_top:
			get_tree().set_input_as_handled()
			MainMenu.toggle()
		elif get_tree().paused and MainMenu.main_menu_is_displayed():
			get_viewport().set_input_as_handled()
			MainMenu.toggle()
