extends Control

export(Vector2) var DirectionUnitVector = Vector2(-1,0)

export(DirectionalMenu.HDirection) var HDirection = DirectionalMenu.HDirection.LEFT
export(DirectionalMenu.VDirection) var VDirection = DirectionalMenu.VDirection.MIDDLE

var template_MenuItem = preload("res://addons/directional_menu/scenes/MenuItem/MenuItem.tscn")
var menu_item_instance = null

var item_holder = Control.new()
var item_node: Node = null
var index := 0

func _init():
	add_child(item_holder)
	item_holder.rect_size = Vector2(0,0)

func _ready():
	DirectionUnitVector = DirectionUnitVector.normalized()

func clear_item():
	for child in item_holder.get_children():
		child.queue_free()
	
	if item_node:
		if is_instance_valid(item_node):
			item_node.queue_free()
		item_node = null
	
	if menu_item_instance:
		if is_instance_valid(menu_item_instance):
			menu_item_instance.queue_free()
		menu_item_instance = null


func set_item(node: Control, distance: float = 72.0, spread_factor: Vector2 = Vector2.ONE):
	clear_item()
	item_node = node
	var new_menu_item = template_MenuItem.instance()
	item_holder.add_child(new_menu_item)
	item_holder.rect_position = DirectionUnitVector * distance * spread_factor
	new_menu_item.set_direction(HDirection, VDirection)
	new_menu_item.setup(node)
	if node.has_method("set_menu_direction"):
		node.set_menu_direction(HDirection, VDirection)

func set_highlight(value: bool = false):
	if item_node and is_instance_valid(item_node):
		if item_node.has_method("set_highlight"):
			item_node.set_highlight(value)
