extends Control


func set_menu_direction(direction_h: int, direction_v: int):
	$HintUp.visible = (
		(direction_h == DirectionalMenu.HDirection.CENTER) and \
		(direction_v == DirectionalMenu.VDirection.TOP)
	)
	$HintDown.visible = (
		(direction_h == DirectionalMenu.HDirection.CENTER) and \
		(direction_v == DirectionalMenu.VDirection.BOTTOM)
	)
	$HintLeft.visible = (
		(direction_h == DirectionalMenu.HDirection.LEFT) and \
		(direction_v == DirectionalMenu.VDirection.MIDDLE)
	)
	$HintRight.visible = (
		(direction_h == DirectionalMenu.HDirection.RIGHT) and \
		(direction_v == DirectionalMenu.VDirection.MIDDLE)
	)
	$HintRightBottom.visible = (
		(direction_h == DirectionalMenu.HDirection.RIGHT) and \
		(direction_v == DirectionalMenu.VDirection.BOTTOM)
	)
	$HintRightTop.visible = (
		(direction_h == DirectionalMenu.HDirection.RIGHT) and \
		(direction_v == DirectionalMenu.VDirection.TOP)
	)
	$HintLeftTop.visible = (
		(direction_h == DirectionalMenu.HDirection.LEFT) and \
		(direction_v == DirectionalMenu.VDirection.TOP)
	)
	$HintLeftBottom.visible = (
		(direction_h == DirectionalMenu.HDirection.LEFT) and \
		(direction_v == DirectionalMenu.VDirection.BOTTOM)
	)


func set_highlight(value: bool):
	$PanelHighlight.visible = value
