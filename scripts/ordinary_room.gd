extends StaticBody2D
@export var enemys_count = 10
@export var decore_count = 5

var pos = Vector2i(0, 0)
var room_address: Vector2i
const width = 1056
const height = 800
const border = Vector2(320, 64)


func _ready() -> void:
	Signals.connect("teleport", Callable(self, "_on_interact"))


func set_pos(idx_x: int, idx_y: int):
	room_address = Vector2i(idx_x, idx_y)
	
	var x = (width + border.x) * idx_x
	var y = (height + border.y) * idx_y
	
	pos = Vector2(x, y) 
	if Vector2i(pos) != Vector2i(0, 0):
		$Enemys.create(enemys_count)

	for i in get_children():
		i.position.x += x
		i.position.y += y

func _on_interact(coord: Vector2i, address: Vector2i):
	if address == room_address:
		for i in get_children():
			i.show()


func create_doors(left: bool = false, right: bool = false, top: bool = false, bottom: bool = false):
	$Doors.create(left, right, top, bottom)
	$Doors.set_coord(Vector2i(pos.x + 864 / 2, pos.y + 544 / 2))
	
func hide_room():
	for i in get_children():
		i.hide()
