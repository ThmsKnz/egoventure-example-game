# EgoVenture Inventory system
extends Control


# Emitted, when another inventory item was triggered
signal triggered_inventory_item(first_item, second_item)

# Emitted when the player released an item
signal released_inventory_item(item)


# The currently selected inventory item or null
var selected_item: InventoryItemNode = null

# Wether the inventory is currently activated
var activated: bool = false

# Wether the inventory item was just released (to prevent other
# actions to be carried out)
var just_released: bool = false

# Wether to ignore a game pause
var ignore_pause: bool = false: set = _set_ignore_pause


# The list of inventory items
var _inventory_items: Array

# The size to scroll around. Defaults to the inventory height
var _scroll_size: int

# The current width of all inventory items
var _items_width: int = 0


# Hide the activate and menu button on touch devices
func _ready():
	if EgoVenture.is_touch:
		$Canvas/InventoryAnchor/Panel/InventoryPanel/Reveal.show()
		$Canvas/InventoryAnchor/Panel/InventoryPanel/Menu.show()
	else:
		$Canvas/InventoryAnchor/Panel/InventoryPanel/Reveal.hide()
		$Canvas/InventoryAnchor/Panel/InventoryPanel/Menu.hide()
	$Canvas/InventoryAnchor/Panel/InventoryPanel/ScrollContainer.\
			get_h_scroll_bar().scale.x = 0
	$Canvas/InventoryAnchor/Panel/InventoryPanel/ScrollContainer.\
			get_h_scroll_bar().modulate = Color(0, 0, 0, 0)
	$Canvas/InventoryAnchor/Panel/InventoryPanel/ArrowLeft.hide()
	$Canvas/InventoryAnchor/Panel/InventoryPanel/ArrowRight.hide()


# Reset just_released
func _process(_delta):
	just_released = false
	$Canvas/InventoryAnchor/Panel/InventoryPanel/ArrowLeft.visible = \
			$Canvas/InventoryAnchor/Panel/InventoryPanel/ScrollContainer\
			.scroll_horizontal > 0
	
	var _scroll = $Canvas/InventoryAnchor/Panel/InventoryPanel/ScrollContainer
	
	$Canvas/InventoryAnchor/Panel/InventoryPanel/ArrowRight.visible = \
			_items_width > _scroll.get_rect().size.x
			
	$Canvas/InventoryAnchor/Panel/InventoryPanel/ArrowRight.visible = \
			_scroll.get_rect().size.x + _scroll.scroll_horizontal < \
			_items_width


# Handle inventory drop events and border trigger for mouse
#
# ** Parameters **
#
# - event: Event received
func _input(event: InputEvent):
	if not DetailView.is_visible:
		# Drop the inventory item on RMB and two finger touch
		if Inventory.selected_item != null and \
				 event is InputEventMouseButton and \
				(event as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT \
				and not (event as InputEventMouseButton).pressed:
			release_item()
			just_released = true
		elif Inventory.selected_item != null and \
				event is InputEventScreenTouch and \
				(event as InputEventScreenTouch).index == 2 and \
				not (event as InputEventScreenTouch).pressed:
			release_item()
			just_released = true
		elif ! EgoVenture.is_touch and event is InputEventMouseMotion and \
				$Timer.is_stopped():
			# Activate the inventory when reaching the upper screen border
			if ! activated and get_viewport().get_mouse_position().y <= 10:
				toggle_inventory()
			# Deactivate the inventory when the mouse is below it
			elif activated and \
					get_viewport().get_mouse_position().y \
					> $Canvas/InventoryAnchor/Panel.size.y:
				toggle_inventory()


# Configure the inventory. Should be call by a game core singleton
# 
# ** Parameters **
#
# - configuration: The game configuration
func configure(configuration: GameConfiguration):
	$Canvas/InventoryAnchor/Panel/InventoryPanel/Menu.texture_normal = \
			configuration.inventory_texture_menu
	$Canvas/InventoryAnchor/Panel/InventoryPanel/Notepad.texture_normal = \
			configuration.inventory_texture_notepad
	$Canvas/InventoryAnchor/Panel/InventoryPanel/ArrowLeft.texture_normal = \
			configuration.inventory_texture_left_arrow
	$Canvas/InventoryAnchor/Panel/InventoryPanel/ArrowRight.texture_normal = \
			configuration.inventory_texture_right_arrow
	$Canvas/InventoryAnchor.theme = configuration.design_theme
	$Canvas/InventoryAnchor/Panel.custom_minimum_size.y = configuration.inventory_size
	_scroll_size = configuration.inventory_size
	
	if EgoVenture.is_touch:
		$Canvas/InventoryAnchor/Panel.add_theme_stylebox_override(
			"panel",
			$Canvas/InventoryAnchor/Panel.get_theme_stylebox("inventory_panel_touch", "Panel")
		)
	else:
		$Canvas/InventoryAnchor/Panel.add_theme_stylebox_override(
			"panel",
			$Canvas/InventoryAnchor/Panel.get_theme_stylebox("inventory_panel", "Panel")
		)
	
	$Canvas/InventoryAnchor/Panel/InventoryPanel/Reveal.texture_normal = \
		configuration.inventory_texture_reveal
		
	$Canvas/InventoryAnchor.offset_top = configuration.inventory_size * -1
	
	var animation: Animation = $Animations.get_animation("Activate")
	animation.track_set_key_value(
		0,
		0,
		Vector2(0,configuration.inventory_size * -1)
	)
	
	if DisplayServer.is_touchscreen_available():
		$Animations.play("Activate")
	
	DetailView.get_node("Panel").theme = configuration.design_theme


# Disable the inventory system
func disable():
	$Canvas/InventoryAnchor/Panel.hide()


# Enable the inventory system
func enable():
	$Canvas/InventoryAnchor/Panel.show()


# Add an item to the inventory
#
# ** Parameters **
#
# - item: Item to add to the inventory
# - skip_show: Skip the reveal animation of the inventory bar
# - allow_duplicate: Allow to add an inventory item already in the inventory
# - position: Position in the list of inventory items where to add the new
#   item (defaults to the end of the list)
func add_item(
	item: InventoryItem, 
	skip_show: bool = false, 
	allow_duplicate: bool = false, 
	position: int = _inventory_items.size()
):
	if not allow_duplicate and has_item(item):
		print(
			"Item %s already is in the inventory. Refusing to add it twice" % \
				item.title
		)
		return
	var inventory_item_node = InventoryItemNode.new()
	inventory_item_node.configure(item)
	inventory_item_node.triggered_inventory_item.connect(
		self._on_triggered_inventory_item
	)
	_inventory_items.insert(position, inventory_item_node)
	_update()
	
	if _inventory_items.size() > 1:
		_items_width += \
			$Canvas/InventoryAnchor/Panel/InventoryPanel/ScrollContainer/Inventory.get_theme_constant("separation")
	_items_width += inventory_item_node.get_rect().size.x
	
	if not EgoVenture.is_touch and not activated and not skip_show:
		# Briefly show the inventory when it is not activated
		toggle_inventory()
		$Timer.start()
		await $Timer.timeout
		$Timer.stop()
		toggle_inventory()


# Remove item from the inventory
# 
# ** Parameters **
# 
# - item: Item to remove from the inventory
func remove_item(item: InventoryItem):
	var found_index = -1
	for index in range(_inventory_items.size()):
		if (_inventory_items[index] as InventoryItemNode).item == item:
			found_index = index
	if found_index != -1:
		if selected_item == _inventory_items[found_index]:
			release_item()
		
		if _inventory_items.size() > 1:
			_items_width -= \
				$Canvas/InventoryAnchor/Panel/InventoryPanel/ScrollContainer/Inventory.get_theme_constant("separation")
		_items_width -= _inventory_items[found_index].get_rect().size.x
		_inventory_items.remove_at(found_index)
		_update()


# Release the currently selected item
func release_item():
	emit_signal("released_inventory_item", selected_item.item)
	selected_item.texture_normal = \
			(selected_item.item as InventoryItem).image_normal
	selected_item.modulate.a = 1
	selected_item = null
	if not EgoVenture.is_touch:
		Cursors.reset(Cursors.Type.DEFAULT)
		Speedy.keep_shape = false


# Returns the current list of inventory items
func get_items() -> Array:
	var items = [] 
	for item in _inventory_items:
		items.append(item.item)
	return items
	
	
# Check, wether the player carries a specific item
#
# ** Parameters **
#
# - needle: item searched for
#
# - returns: true if the player is carrying the item, false if not.
func has_item(needle: InventoryItem) -> bool:
	for item in _inventory_items:
		if item.item == needle:
			return true
	return false


# Show or hide the inventory
func toggle_inventory():
	if activated:
		$Animations.play_backwards("Activate")
		activated = false
	else:
		$Animations.play("Activate")
		activated = true


# Emit signal, that the notepad was pressed
func _on_Notepad_pressed():
	if selected_item == null:
		Notepad.display()


# Emit signal, that the menu was pressed
func _on_Menu_pressed():
	MainMenu.toggle()


# Emit a signal, that one item was triggered on another item	
# 
# ** Parameters **
#
# - first_item: First item that is used
# - second_item: Second item that is used
func _on_triggered_inventory_item(
	first_item: InventoryItem,
	second_item: InventoryItem
):
	emit_signal("triggered_inventory_item", first_item, second_item)


# Update the inventory item view by simply removing all items and re-adding them
func _update():
	var inventory_panel = \
			$Canvas/InventoryAnchor/Panel/InventoryPanel\
			/ScrollContainer/Inventory
	for child in inventory_panel.get_children():
		inventory_panel.remove_child(child)
	for item in _inventory_items:
		inventory_panel.add_child(item)


# React to touches on the reveal button
#
# ** Parameters **
#
# - event: event that was triggered
func _on_Reveal_gui_input(event):
	if event is InputEventScreenTouch:
		if Inventory.selected_item == null:
			if (event as InputEventScreenTouch).pressed:
				var push_event = InputEventAction.new()
				push_event.button_pressed = true
				push_event.action = "hotspot_indicator"
				Input.parse_input_event(push_event)
			else:
				var release_event = InputEventAction.new()
				release_event.button_pressed = false
				release_event.action = "hotspot_indicator"
				Input.parse_input_event(release_event)
		elif not (event as InputEventScreenTouch).pressed:
			if DetailView.is_visible:
				DetailView.hide()
			else:
				DetailView.show_with_item(Inventory.selected_item.item)


# Wether to ignore game pauses
#
# ** Parameters **
#
# - value: Wether to ignore game pauses or not
func _set_ignore_pause(value: bool):
	ignore_pause = value
	
	if ignore_pause:
		$Canvas/InventoryAnchor.process_mode = Node.PROCESS_MODE_ALWAYS
		process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		$Canvas/InventoryAnchor.process_mode = Node.PROCESS_MODE_PAUSABLE
		process_mode = Node.PROCESS_MODE_PAUSABLE


# Handle moving the inventory to the right
func _on_ArrowRight_pressed() -> void:
	var _scroll = $Canvas/InventoryAnchor/Panel/InventoryPanel/ScrollContainer
	_scroll.scroll_horizontal += _scroll_size
	

# Handle moving the inventory to the left
func _on_ArrowLeft_pressed() -> void:
	$Canvas/InventoryAnchor/Panel/InventoryPanel/ScrollContainer\
			.scroll_horizontal -= _scroll_size
