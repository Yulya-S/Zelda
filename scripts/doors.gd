extends Node2D

const width = 864 + 140
const height = 544 + 70


var doors = [false, false, false, false]
var exit_coords = [Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0)]


func _ready() -> void:
	pass


func create(left: bool = false, right: bool = false,
			top: bool = false, bottom: bool = false):
	doors = [left, right, top, bottom]
	if top:
		for i in range(4):
			for l in range(3):
				$TileMapLayer.set_cell(Vector2i(12 + l, -3 + i), 0, Vector2i(7 + l, 9 + i))
	if bottom:
		$TileMapLayer.set_cell(Vector2i(12, 16), 0, Vector2i(7, 0))
		$TileMapLayer.set_cell(Vector2i(14, 16), 0, Vector2i(2, 0))
		$TileMapLayer.erase_cell(Vector2i(13, 16))
	if left:
		for i in range(3):
			$TileMapLayer.set_cell(Vector2i(0, 6 + i), 0, Vector2i(7, 6 + i))
		$TileMapLayer.set_cell(Vector2i(0, 9), 0, Vector2i(7, 0))
	if right:
		for i in range(3):
			$TileMapLayer.set_cell(Vector2i(26, 6 + i), 0, Vector2i(2, 6 + i))
		$TileMapLayer.set_cell(Vector2i(26, 9), 0, Vector2i(2, 0))


func set_coord(room_coord: Vector2i):
	var neighbour_coord = [[-1, 0], [1, 0], [0, -1.1], [0, 1]]
	for i in range(len(neighbour_coord)):
		if doors[i]:
			exit_coords[i] = Vector2i(
				room_coord.x + width * neighbour_coord[i][0],
				room_coord.y + height * neighbour_coord[i][1]
				)


func _on_to_left_door_body_entered(body: Node2D) -> void:
	if doors[0] and body.name == "Player":
		hide_room()
		Signals.emit_signal("teleport", exit_coords[0],
							Vector2i($"..".room_address.x - 1, $"..".room_address.y))


func _on_to_right_door_body_entered(body: Node2D) -> void:
	if doors[1] and body.name == "Player":
		hide_room()
		Signals.emit_signal("teleport", exit_coords[1],
							Vector2i($"..".room_address.x + 1, $"..".room_address.y))


func _on_to_top_door_body_entered(body: Node2D) -> void:
	if doors[2] and body.name == "Player":
		hide_room()
		Signals.emit_signal("teleport", exit_coords[2],
							Vector2i($"..".room_address.x, $"..".room_address.y - 1))


func _on_to_bottom_door_body_entered(body: Node2D) -> void:
	if doors[3] and body.name == "Player":
		hide_room()
		Signals.emit_signal("teleport", exit_coords[3],
							Vector2i($"..".room_address.x, $"..".room_address.y + 1))


func hide_room():
	var room = $".."
	for i in room.get_children():
		i.hide()
