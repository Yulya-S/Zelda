extends StaticBody2D

var pos = Vector2(0, 0)
const width = 1056
const height = 800
const border = Vector2(320, 64)


func _ready() -> void:
	pass


func set_pos(idx_x: int, idx_y: int):
	var x = (width + border.x) * idx_x
	var y = (height + border.y) * idx_y
	
	pos = Vector2(x, y) 
	
	$Wall.position.x = x
	$Wall.position.y = y
	$Floor.position.x = x
	$Floor.position.y = y
	$Doors.position.x = x
	$Doors.position.y = y
	$Obstacles.position.x = x
	$Obstacles.position.y = y


func create_doors(left: bool = false, right: bool = false, top: bool = false, bottom: bool = false):
	$Doors.create(left, right, top, bottom)
	$Doors.set_coord(Vector2i(pos.x + 864 / 2, pos.y + 544 / 2))
