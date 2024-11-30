extends Node2D
@export var objects_count = 10
@onready var player_scene = $"../../Player"

const enemy_scene = "res://scenes/persons/Enemy.tscn"
const vase_scene = "res://scenes/rooms/obj/vase.tscn"

var room_address: Vector2i
var pos = Vector2i(0, 0)
var is_show: bool = true

const width = 1056
const height = 800
const border = Vector2(320, 64)


func _process(delta: float) -> void:
	if not is_show and player_scene.room_address == room_address: show_room()


func set_pos(idx_x: int, idx_y: int):
	room_address = Vector2i(idx_x, idx_y)
	pos = Vector2((width + border.x) * idx_x, (height + border.y) * idx_y) 
	if Vector2i(pos) != Vector2i(0, 0): create_enemys()
	for i in get_children(): i.position += pos


func create_doors(left: bool = false, right: bool = false, top: bool = false, bottom: bool = false):
	$Doors.create(left, right, top, bottom)
	$Doors.set_coord(Vector2(pos.x + 864 / 2, pos.y + 544 / 2))
	

func create_enemys():
	var obstacles_scene = $Obstacles
	var wall_scene = $Wall
	var enemy = load(enemy_scene)
	var vase = load(vase_scene)
	var coords = []
	var count: int = 0
	while count < objects_count:
		var rand_coord = Vector2i(randi_range(2, 23), randi_range(2, 13))
		if rand_coord not in coords and wall_scene.get_cell_source_id(rand_coord) \
		   and obstacles_scene.get_cell_source_id(rand_coord) == -1:
			coords.append(rand_coord)
			rand_coord = Vector2i(rand_coord.x * 32, rand_coord.y * 32)
			var enemy_appearance: int = randi_range(0, 15)
			var obj
			if enemy_appearance < 7: obj = vase.instantiate()
			elif enemy_appearance < 20:
				obj = enemy.instantiate()
				count += 1
			obj.set_pos(rand_coord)
			$objects.add_child(obj)


func show_room():
	Signals.emit_signal("add_room_to_map", room_address, self)
	is_show = true
	for i in get_children(): i.show()


func hide_room():
	is_show = false
	for i in get_children(): i.hide()
