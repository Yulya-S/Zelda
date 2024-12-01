extends Node2D
@onready var tile_map = $TileMapLayer
@onready var parent_room = $".."

const width = 864 + 140
const height = 544 + 70

var doors = [false, false, false, false]
var exit_coords = [Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0)]


# открытие дверей
func create(left: bool = false, right: bool = false,
			top: bool = false, bottom: bool = false):
	doors = [left, right, top, bottom]
	if top:
		for i in range(4):
			for l in range(3):
				tile_map.set_cell(Vector2i(12 + l, -3 + i), 0, Vector2i(7 + l, 9 + i))
	if bottom:
		tile_map.set_cell(Vector2i(12, 16), 0, Vector2i(7, 0))
		tile_map.set_cell(Vector2i(14, 16), 0, Vector2i(2, 0))
		tile_map.erase_cell(Vector2i(13, 16))
	if left:
		tile_map.set_cell(Vector2i(0, 9), 0, Vector2i(7, 0))
		for i in range(3):
			tile_map.set_cell(Vector2i(0, 6 + i), 0, Vector2i(7, 6 + i))
	if right:
		tile_map.set_cell(Vector2i(26, 9), 0, Vector2i(2, 0))
		for i in range(3):
			tile_map.set_cell(Vector2i(26, 6 + i), 0, Vector2i(2, 6 + i))


# установление расположения сцены дверей
func set_coord(room_coord: Vector2):
	var neighbour_coord = [[-1, 0], [1, 0], [0, -1.1], [0, 1]]
	for i in range(len(neighbour_coord)):
		if doors[i]:
			exit_coords[i] = Vector2i(
				room_coord.x + width * neighbour_coord[i][0],
				room_coord.y + height * neighbour_coord[i][1]
				)


# отравка сигнала перехода игрока в другую комнату
func _teleport(door_idx: int, name: String, coord: Vector2):
	if doors[door_idx] and name == "Player":
		parent_room.hide_room()
		Signals.emit_signal("teleport", exit_coords[door_idx], coord)


# Обработка входа в левую дверь
func _on_to_left_door_body_entered(body: Node2D) -> void:
	_teleport(0, body.name, Vector2(parent_room.room_address.x - 1, parent_room.room_address.y))

# Обработка входа в правую дверь
func _on_to_right_door_body_entered(body: Node2D) -> void:
	_teleport(1, body.name, Vector2(parent_room.room_address.x + 1, parent_room.room_address.y))

# Обработка входа в верхнюю дверь
func _on_to_top_door_body_entered(body: Node2D) -> void:
	_teleport(2, body.name, Vector2(parent_room.room_address.x, parent_room.room_address.y - 1))

# Обработка входа в нижнуюю дверь
func _on_to_bottom_door_body_entered(body: Node2D) -> void:
	_teleport(3, body.name, Vector2(parent_room.room_address.x, parent_room.room_address.y + 1))
