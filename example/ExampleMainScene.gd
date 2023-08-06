extends Control

onready var menu = $DialogBar/Background/DirectionalMenu


func _ready():
	menu.connect("menu_item_selected", self, "_on_DirectionalMenu_menu_item_selected")

func _input(event):
	# Input.is_action_pressed() etc is a more elegant way of doing things,
	# but this example implements a way which is independent
	# from any project settings
	
	
	
	if (event is InputEventKey) and (not event.echo):
		if event.scancode in [KEY_W, KEY_A, KEY_S, KEY_D]:
			# In the part of your code where you get directional user input
			# (keyboard, analog stick, DPad, on-screen stick, etc)
			# you should get a Vector2 where X axis is moving right,
			# and Y axis is moving up
			# Then feed this to DirectionalMenu's input_direction()
			# every time this input changes
			
			# Intuitive mouse is trickier, as you need to capture the cursor
			# when the menu shows up, then track the difference to that point
			# and normalize it. But if you're using mouse, a DirectionalMenu is 
			# probably not very relevant
			
			var axis_x = 0.0
			if Input.is_key_pressed(KEY_A):
				axis_x -= 1
			if Input.is_key_pressed(KEY_D):
				axis_x += 1
			
			var axis_y = 0.0
			if Input.is_key_pressed(KEY_S):
				axis_y -= 1
			if Input.is_key_pressed(KEY_W):
				axis_y += 1
		
			var direction = Vector2(axis_x, axis_y).normalized()
			# You don't have to worry if the menu is active. It handles itself
			menu.input_direction(direction)
		
		
		
		
		
		
		if (event.scancode in [KEY_ENTER, KEY_SPACE, KEY_E]) and (event.pressed):
			# In the part of your code where you get action user input
			# (action key, joystick button, on-screen button, etc)
			# for the action you want the player to use to select options
			# in the menu, simply call the DirectionalMenu's confirm() method
			
			# You don't have to worry if the menu is active. It handles itself
			menu.confirm()
		
			# (If you call confirm(false) it will not automatically hide the
			# menu, so you can design your own fading animations)
		
		
		
		if (event.scancode in [KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9]) and (event.pressed):
			# Below demonstrates how to assemble menus
			var num_items = 1
			match event.scancode:
				KEY_1: num_items = 1
				KEY_2: num_items = 2
				KEY_3: num_items = 3
				KEY_4: num_items = 4
				KEY_5: num_items = 5
				KEY_6: num_items = 6
				KEY_7: num_items = 7
				KEY_8: num_items = 8
				KEY_9: num_items = 1 + (randi() % 8)
			
			# When invoking the menu, you pass an Array where each item is
			# a node instance (derived from the Control family) NOT ADDED
			# TO ANY PARENT (the menu will add_child() it).
			# Each of these nodes is the UI item you want to display as option
			# There are no restrictions: they can be icons, text, even full
			# viewport scenes. Anything you can fit in a Control can be there
			# They don't necessarily have to be instances of the same scene, 
			# each item in the list is independent and can be a completely 
			# unique scene if you want.
			#
			# The only special requirements are: it should have 2 methods:
			#
			#   - set_highlight(value: bool) -> called to set highlight on or
			#         off to show which item has focus (this can trigger 
			#         animations if you want)
			#
			#   (below is optional)
			#   - set_menu_direction(direction_h, direction_v) -> called to
			#         inform your node what position it is allocated in the
			#         menu, so you can e.g. show hint icons about the button to
			#         press, or realign text (so left items' text aligns right,
			#         and right items' text align left), etc.
			#         Arguments are:
			#             direction_h: DirectionalMenu.HDirection.LEFT,
			#                          DirectionalMenu.HDirection.CENTER,
			#                          DirectionalMenu.HDirection.RIGHT
			#             direction_v: DirectionalMenu.VDirection.TOP,
			#                          DirectionalMenu.VDirection.MIDDLE,
			#                          DirectionalMenu.VDirection.BOTTOM
			# 
			# The nodes will be parented to a ReferenceRect in 
			# res://addons/directional_menu/scenes/MenuItem/MenuItem.tscn
			# (in case you want to change the size)
			# If your menu items will vary too much in size, might be a good 
			# idea to set the MenuItem size to (0, 0) and use it as position
			# reference only
			# In that case you MUST use set_menu_direction() to change
			# the anchors. Simpler and safer to just go along a fixed maximum
			# size and just (maybe) resize MenuItem and use as is.
			
			var menu_items = []
			for i in range(num_items):
				var this_item = preload("res://example/MenuOption.tscn").instance()
				this_item.get_node("LabelName").text = "Item %d" % (i+1)
				menu_items.append(this_item)
			
			# Now menu_items is an Array containing a number of nodes as 
			# menu options, all we have to do is supply it to the menu
			
			menu.show_menu(menu_items)
			
			# A signal will be triggered when something is selected.
			
			# If instead you call show_menu(menu_items, false) it will set the
			# items but not automatically show the menu, so you can design your
			# own fading animations
		
		
		
		if (event.scancode == KEY_X) and (event.pressed):
			menu.RadialPattern = menu.MenuPatterns.X
			$LabelRadialPattern.text = "X"
		
		if (event.scancode == KEY_C) and (event.pressed):
			menu.RadialPattern = menu.MenuPatterns.CROSS
			$LabelRadialPattern.text = "Cross"


func _on_DirectionalMenu_menu_item_selected(index, item_node):
	# When an item is selected in the menu, this signal is triggered
	# The first argument is a numerical index of the option (matching the Array
	# you passed when invoking show_menu() ), the second is the node instance
	# you passed (the content item in that Array), so you can actually store
	# custom data inside those nodes to be used here
	print("Selected option %d - UI node %s" % [index, str(item_node)])

