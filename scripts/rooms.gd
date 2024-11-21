extends Node2D

const MAP_ROOT = "res://rooms/room"
const UNIC_MAP_ROOT = "res://rooms/unic_room"
var room_array = []
var unic_room_array = []


func _ready() -> void:
	get_room_array()
	get_unic_room_array()
	
	var x = 0
	var y = 0
	var room = room_array[0].instantiate()
	var coords = {[x, y]: room}
	add_child(room)
	
	for i in range(10):
		while [x, y] in coords:
			var rnd = randi_range(0, 3)
			match rnd:
				0: x += 1
				1: x -= 1
				2: y += 1
				3: y -= 1
				
		var unic_room = randi_range(0, 1)
		if len(unic_room_array) == 0:
			unic_room = 0

		if unic_room:
			var rand_idx = randi_range(0,unic_room_array.size()-1)
			room = unic_room_array[rand_idx].instantiate()
			unic_room_array.pop_at(rand_idx)
		else:
			room = room_array[randi_range(0,room_array.size()-1)].instantiate()

		room.set_pos(x, y)
		room.hide_room()
		coords[[x, y]] = room
		add_child(room)
	
	set_doors(coords)


func set_doors(coords:Dictionary):
	for i in coords.keys():
		var x = i[0]
		var y = i[1]
		var neighbours = [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]]
		coords[i].create_doors(
			[x - 1, y] in coords.keys(), [x + 1, y] in coords.keys(),
			[x, y - 1] in coords.keys(), [x, y + 1] in coords.keys()
			)


func get_room_path(index):
	return MAP_ROOT + str(index) + ".tscn"


func get_room_array():
	var i = 1
	while true:
		if load(get_room_path(i)) != null:
			room_array.append(load(get_room_path(i)))
		else:
			break
		i+=1


func get_unic_room_path(index):
	return UNIC_MAP_ROOT + str(index) + ".tscn"


func get_unic_room_array():
	var i = 1
	while true:
		if load(get_unic_room_path(i)) != null:
			unic_room_array.append(load(get_unic_room_path(i)))
		else:
			break
		i+=1


func _process(delta: float) -> void:
	pass
