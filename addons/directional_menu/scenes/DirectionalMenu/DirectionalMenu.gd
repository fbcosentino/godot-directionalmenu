# DirectionalMenu by Fernando Cosentino
# github.com/fbcosentino
# MIT License


extends Control
class_name DirectionalMenu

signal menu_item_selected(item_index, item_data)

const sin_eighth = sin(PI/8.0)

enum HDirection {
	LEFT,
	CENTER,
	RIGHT
}

enum VDirection {
	TOP,
	MIDDLE,
	BOTTOM
}


export(float) var DistanceFromCenterPx = 72.0
export(Vector2) var SpreadFactor = Vector2.ONE



# As you include options in a menu, they show up in the order below.
# The keys in the dictionary are the total number of items in the menu,
# while the values are a list cntaining the directions.
# Each item in the list is a sublist with horizontal and vertical direction
# (Direction is not alignment. Left means the item shows to the left of
# the menu, not that the text would be aligned to left margin - it would,
# instead, be aligned to the _right_ margin.)
#
# There are two versions: one prioritises screen space so items show in X
# pattern first. Not an issue for analog sticks, but might be less 
# comfortable if controller is DPad
#
# Second version uses more vertical screen space, as items show in cross
# pattern first. Will be comfortable with all kinds of controllers.
enum MenuPatterns {
	X,
	CROSS
}
export(MenuPatterns) var RadialPattern = MenuPatterns.X

# This is a constant definition disguised as a function, so it goes in the top of the file
func get_menu_direction_order(item_count: int):
	if (item_count < 1) or (item_count > 8):
		push_error("DirectionalMenu supports between 1 and 8 items (%d were supplied)" % item_count)
		return []
	
	# Return value can have more items than needed. They are just ignored.
	
	# Pattern doesn't matter for menus with 1 or 2 items
	# They always show as left/right
	if (item_count <= 2):
		return [
				[HDirection.LEFT, VDirection.MIDDLE],
				[HDirection.RIGHT, VDirection.MIDDLE],
			]

	match RadialPattern:
		MenuPatterns.X:
			match item_count:
				# Menu with 3 items forms a triangle :-
				3: return [
					[HDirection.LEFT, VDirection.TOP],
					[HDirection.RIGHT, VDirection.MIDDLE],
					[HDirection.LEFT, VDirection.BOTTOM],
				]
				
				# Menu with 4 items forms a X
				4: return [
					[HDirection.LEFT, VDirection.TOP],
					[HDirection.RIGHT, VDirection.TOP],
					[HDirection.LEFT, VDirection.BOTTOM],
					[HDirection.RIGHT, VDirection.BOTTOM],
				]
				
				# Menu with 5 items splits a horizontal 3 - 2
				5: return [
					[HDirection.LEFT, VDirection.TOP],
					[HDirection.LEFT, VDirection.MIDDLE],
					[HDirection.LEFT, VDirection.BOTTOM],
					[HDirection.RIGHT, VDirection.TOP],
					[HDirection.RIGHT, VDirection.BOTTOM],
				]
				
				# Menu with 6 items splits a horizontal 3 - 3
				6: return [
					[HDirection.LEFT, VDirection.TOP],
					[HDirection.LEFT, VDirection.MIDDLE],
					[HDirection.LEFT, VDirection.BOTTOM],
					[HDirection.RIGHT, VDirection.TOP],
					[HDirection.RIGHT, VDirection.MIDDLE],
					[HDirection.RIGHT, VDirection.BOTTOM],
				]
				
				# Menu with 7 or 8 items adds top and bottom
				7,8: return [
					[HDirection.LEFT, VDirection.TOP],
					[HDirection.CENTER, VDirection.TOP],
					[HDirection.RIGHT, VDirection.TOP],
					[HDirection.LEFT, VDirection.MIDDLE],
					[HDirection.RIGHT, VDirection.MIDDLE],
					[HDirection.LEFT, VDirection.BOTTOM],
					[HDirection.RIGHT, VDirection.BOTTOM],
					[HDirection.CENTER, VDirection.BOTTOM],
				]
				

		MenuPatterns.CROSS:
			match item_count:
				# Menu with 3 items forms a triangle -'-
				3: return [
					[HDirection.LEFT, VDirection.MIDDLE],
					[HDirection.CENTER, VDirection.TOP],
					[HDirection.RIGHT, VDirection.MIDDLE],
				]
				
				# Menu with 4 items forms a cross
				4: return [
					[HDirection.LEFT, VDirection.MIDDLE],
					[HDirection.CENTER, VDirection.TOP],
					[HDirection.RIGHT, VDirection.MIDDLE],
					[HDirection.CENTER, VDirection.BOTTOM],
				]
				
				# Menu with 5 items forms a cross with added topleft
				5: return [
					[HDirection.LEFT, VDirection.MIDDLE],
					[HDirection.LEFT, VDirection.TOP],
					[HDirection.CENTER, VDirection.TOP],
					[HDirection.RIGHT, VDirection.MIDDLE],
					[HDirection.CENTER, VDirection.BOTTOM],
				]
				
				# Menu with 6 items  forms a cross with added topleft and topright
				6: return [
					[HDirection.LEFT, VDirection.MIDDLE],
					[HDirection.LEFT, VDirection.TOP],
					[HDirection.CENTER, VDirection.TOP],
					[HDirection.RIGHT, VDirection.TOP],
					[HDirection.RIGHT, VDirection.MIDDLE],
					[HDirection.CENTER, VDirection.BOTTOM],
				]
				
				# Menu with 7 or 8 items use full circle
				7,8: return [
					[HDirection.LEFT, VDirection.MIDDLE],
					[HDirection.LEFT, VDirection.TOP],
					[HDirection.CENTER, VDirection.TOP],
					[HDirection.RIGHT, VDirection.TOP],
					[HDirection.RIGHT, VDirection.MIDDLE],
					[HDirection.RIGHT, VDirection.BOTTOM],
					[HDirection.CENTER, VDirection.BOTTOM],
					[HDirection.LEFT, VDirection.BOTTOM],
				]


onready var slots := {
	[HDirection.LEFT, VDirection.MIDDLE]: get_node("SlotLeftMiddle"),
	[HDirection.LEFT, VDirection.TOP]: get_node("SlotLeftTop"),
	[HDirection.CENTER, VDirection.TOP]: get_node("SlotCenterTop"),
	[HDirection.RIGHT, VDirection.TOP]: get_node("SlotRightTop"),
	[HDirection.RIGHT, VDirection.MIDDLE]: get_node("SlotRightMiddle"),
	[HDirection.RIGHT, VDirection.BOTTOM]: get_node("SlotRightBottom"),
	[HDirection.CENTER, VDirection.BOTTOM]: get_node("SlotCenterBottom"),
	[HDirection.LEFT, VDirection.BOTTOM]: get_node("SlotLeftBottom"),
	[HDirection.CENTER, VDirection.MIDDLE]: null,
}

var current_menu_items := []

var is_active := false
var current_selected = null










func clear_menu():
	for slot_map in slots:
		if slots[slot_map] != null:
			slots[slot_map].clear_item()
	current_selected = null


func show_menu(menu_items: Array, auto_show_menu: bool = true):
	clear_menu()
	current_menu_items = menu_items
	var item_count = menu_items.size()
	var menu_order = get_menu_direction_order(item_count)
	
	for i in range(item_count):
		var slot_map = menu_order[i]
		if not slot_map in slots:
			push_error("The direction pair %s was not found in the slots dictionary" % str(slot_map))
			return
		var slot = slots[slot_map]
		
		var node = menu_items[i]
		
		slot.set_item(node, DistanceFromCenterPx, SpreadFactor)
		slot.index = i
	
	is_active = true
	if auto_show_menu:
		show()


func hide_menu():
	is_active = false
	hide()


func input_direction(direction: Vector2 = Vector2.ZERO):
	# direction.y is positive UP (it refers to controller axes, not screen)
	if not is_active:
		return
	
	var dir_h = HDirection.CENTER
	var dir_v = VDirection.MIDDLE
	
	if direction.length_squared() > 0.01:
		var dir_norm = direction.normalized()
		
		# each direction has a 45 degree span (plus and minus 22.5)
		
		if dir_norm.x <= (-sin_eighth):
			dir_h = HDirection.LEFT
		elif dir_norm.x >= (sin_eighth):
			dir_h = HDirection.RIGHT
		else:
			dir_h = HDirection.CENTER
		
		if dir_norm.y <= (-sin_eighth):
			dir_v = VDirection.BOTTOM
		elif dir_norm.y >= (sin_eighth):
			dir_v = VDirection.TOP
		else:
			dir_v = VDirection.MIDDLE
	
	var new_selected = slots[ [dir_h, dir_v] ]
	if new_selected != current_selected:
		if current_selected != null:
			# Highlight OFF
			current_selected.set_highlight(false)
		
		if new_selected != null:
			# Highlight ON
			new_selected.set_highlight(true)
		
		current_selected = new_selected
		print(current_selected)

func confirm(auto_hide_menu: bool = true):
	if not is_active:
		return
	
	if current_selected.item_node != null:
		emit_signal("menu_item_selected", current_selected.index, current_selected.item_node)
		if auto_hide_menu:
			hide_menu()
