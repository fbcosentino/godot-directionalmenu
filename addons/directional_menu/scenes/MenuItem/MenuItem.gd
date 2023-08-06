extends ReferenceRect


func setup(node_child: Control):
	add_child(node_child)

func set_direction(direction_h: int, direction_v: int):
	var orig_size = rect_size
	
	match direction_h:
		DirectionalMenu.HDirection.LEFT:
			# Show to the left side, means it's aligned to the right margin
			anchor_left = 1.0
			anchor_right = 1.0
			margin_left = -orig_size.x
			margin_right = 0.0
		
		DirectionalMenu.HDirection.CENTER:
			anchor_left = 0.5
			anchor_right = 0.5
			margin_left = -(orig_size.x*0.5)
			margin_right = (orig_size.x*0.5)
	
		DirectionalMenu.HDirection.RIGHT:
			# Show to the right side, means it's aligned to the left margin
			anchor_left = 0.0
			anchor_right = 0.0
			margin_left = 0.0
			margin_right = orig_size.x

	match direction_v:
		DirectionalMenu.VDirection.TOP:
			# Show to the top, means it's aligned to the bottom margin
			anchor_top = 1.0
			anchor_bottom = 1.0
			margin_top = -orig_size.y
			margin_bottom = 0.0
		
		DirectionalMenu.VDirection.MIDDLE:
			anchor_top = 0.5
			anchor_bottom = 0.5
			margin_top = -(orig_size.y*0.5)
			margin_bottom = (orig_size.y*0.5)
	
		DirectionalMenu.VDirection.BOTTOM:
			# Show to the bottom, means it's aligned to the top margin
			anchor_top = 0.0
			anchor_bottom = 0.0
			margin_top = 0.0
			margin_bottom = orig_size.y
