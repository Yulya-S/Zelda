extends Node2D
@onready var rooms_scene = $rooms
const room_scene = "res://scenes/map/map_room.tscn"

var current_pos = Vector2i(0, 0)
var addresses: Array = []
var min_x: int = 0
var min_y: int = 0
var height: int = 80
var width: int = 100

# данные для статистики
var statistic: Array = [0, 0, 0, 0, 0]
var all_enemys: int = 0 # общее количество врагов
var death_enemys: int = 0 # количество побежденных врагов

func _ready() -> void:
	Signals.connect("add_room_to_map", Callable(self, "_append_room"))
	Signals.connect("teleport", Callable(self, "_teleport"))
	Signals.connect("statistic", Callable(self, "_change"))
	$player.play()
	$statistics/enemy_count/Bone.hide()


func _append_room(address: Vector2i, room: Node2D):
	if address not in addresses:
		addresses.append(address)
		if address.x < min_x:
			min_x = address.x
			for i in rooms_scene.get_children():
				i.position.x += width
		if address.y < min_y:
			min_y = address.y
			for i in rooms_scene.get_children():
				i.position.y += height
		rooms_scene.add_child(load(room_scene).instantiate())
		rooms_scene.get_child(-1).set_room(room)
		rooms_scene.get_child(-1).position.y = (min_y * height * -1) + address.y * height
		rooms_scene.get_child(-1).position.x = (min_x * width * -1) + address.x * width
		_teleport(Vector2i(0, 0), address)


func _teleport(coord: Vector2i, address: Vector2i):
	current_pos = address
	$player.position.y = (min_y * height * -1) + address.y * height + 30
	$player.position.x = (min_x * width * -1) + address.x * width + 45


func _change(idx: int, count: int = 1):
	if idx > 4:
		if idx == 5:
			all_enemys += count
			$statistics/enemy_count.set_text(str(all_enemys))
		elif idx == 6:
			death_enemys += 1
			var text = str(all_enemys - death_enemys)
			if all_enemys - death_enemys == 0:
				Signals.emit_signal("new_message", "Комната босса была открыта, нажмите M")
				$statistics/message.set_text("Комната босса открыта\nНажмите E, для перехода")
				$statistics/enemy_count.set_text("")
				$statistics/enemy_count/Bone.show()
			else: $statistics/enemy_count.set_text(text)
	else:
		statistic[idx] += count
		var statistic_text = ""
		for i in statistic:
			statistic_text += str(i) + "\n"
		$statistics/values.text = statistic_text
	
