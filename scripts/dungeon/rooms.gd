extends Node2D
const ROOM_ROOT = "res://scenes/rooms/room"
const UNIC_ROOM_ROOT = "res://scenes/rooms/unic_room"

var room_array = []
var unic_room_array = []
var room_coords = []
var xs = []
var ys = []


# Добавление шаблонов комнат
func load_rooms():
	var i = max(len(room_array), len(unic_room_array)) + 1
	if load(ROOM_ROOT + str(i) + ".tscn") != null:
		room_array.append(load(ROOM_ROOT + str(i) + ".tscn"))
	if load(UNIC_ROOM_ROOT + str(i) + ".tscn") != null:
		unic_room_array.append(load(UNIC_ROOM_ROOT + str(i) + ".tscn"))
	return load(ROOM_ROOT + str(i) + ".tscn") == null \
		   and load(UNIC_ROOM_ROOT + str(i) + ".tscn") == null


# Генерация подземелья
func generate_room():
	var coord = Vector2(0, 0)
	if len(room_coords) > 0:
		coord = room_coords[-1]
	var room
	var attempts: int = 0 # счеткик для остановки попытки создания комнаты
	while coord in room_coords and len(room_coords) > 0:
		var rnd = randi_range(0, 3)
		match rnd:
			0: coord.x += 1
			1: coord.x -= 1
			2: coord.y += 1
			3: coord.y -= 0
		# проверяем что бы комнат по x и y было не больше 7
		if (len(xs) > 0 and len(xs) > 6 and coord.x in xs) \
			or (len(ys) > 0 and len(ys) > 6 and coord.y in ys):
			coord = room_coords[randi_range(0, len(room_coords) - 1)]
		attempts += 1
		if attempts > 10:
			return
	if coord == Vector2(0, 0):
		room = room_array[0].instantiate()
	else:
		# Выбираем тип создаваемой команы (уникальная или обычная)
		var create_unic_room = randi_range(0, 1) if len(unic_room_array) > 0 else 0
		if create_unic_room:
			var idx = randi_range(0, len(unic_room_array) - 1)
			room = unic_room_array[idx].instantiate()
			unic_room_array.pop_at(idx)
		else:
			room = room_array[randi_range(0, len(room_array) - 1)].instantiate()
	# добавляем новую комнату
	room.set_pos(coord.x, coord.y)
	room.hide_room()
	add_child(room)
	if coord.x not in xs: xs.append(coord.x)
	if coord.y not in ys: ys.append(coord.y)
	room_coords.append(coord)
	

# Добавляем комнатам двери
func set_doors(idx):
	if idx >= len(room_coords):
		return false
	var x = room_coords[idx].x
	var y = room_coords[idx].y
	get_child(idx).create_doors(
		Vector2(x - 1, y) in room_coords, Vector2(x + 1, y) in room_coords,
		Vector2(x, y - 1) in room_coords, Vector2(x, y + 1) in room_coords )
	return true
