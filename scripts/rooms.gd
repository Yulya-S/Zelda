extends Node2D

var player_scene = preload("res://scenes/persons/player.tscn")

const MAP_ROOT = "res://scenes/rooms/room"
const UNIC_MAP_ROOT = "res://scenes/rooms/unic_room"

var room_array = []
var unic_room_array = []
@export var start_generate = true
var coords: Dictionary


func _ready() -> void:
	pass
	
	
func generate_dungeon(room_count: int):
	var range_x = [0, 0]
	var range_y = [0, 0]
	var x = 0
	var y = 0
	var room
	for i in range(room_count):
		$"../CanvasLayer2/load".value = i
		var count = 0
		var last_coord = [0, 0]
		while [x, y] in coords:
			var rnd = randi_range(0, 3)
			match rnd:
				0: x += 1
				1: x -= 1
				2: y += 1
				3: y -= 1
			if (range_x[1] - range_x[0] == 6 and (x > range_x[0] or x < range_x[1])) \
				or (range_y[1] - range_y[0] == 6 and (y > range_y[0] or y < range_y[1])):
				x = last_coord[0]
				y = last_coord[1]
			last_coord = [x, y]
			count += 1
			if count >= 10:
				return
				
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
		if x < range_x[0]:
			range_x[0] = x
		if x > range_x[1]:
			range_x[1] = x
		if y < range_y[0]:
			range_y[0] = y
		if y > range_y[1]:
			range_y[1] = y


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
	if start_generate:
		const room_count = 10
		start_generate = false
		$"../CanvasLayer".hide()
		$"../CanvasLayer2/load".max_value = room_count
		
		get_room_array()
		get_unic_room_array()
		coords[[0, 0]] = room_array[0].instantiate()
		add_child(coords[[0, 0]])
		generate_dungeon(room_count)
		set_doors(coords)
		
		#$"../../".add_child($"../../".map_scene.instantiate())
		#$"../../map".hide()
		#Signals.emit_signal("add_room_to_map", Vector2i(0, 0), get_child(0))
		
		#$"..".add_child(player_scene.instantiate())
		#$"../Player/Camera2D".make_current()
		#$"../CanvasLayer".show()
		#$"../CanvasLayer2".queue_free()
		
		
		
