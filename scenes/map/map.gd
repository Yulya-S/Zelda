extends Node2D
const room_scene = "res://scenes/map/room.tscn"

var current_pos = Vector2i(0, 0)
var addresses = []
var min_x = 0
var min_y = 0
var height = 80
var width = 100


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect("add_room_to_map", Callable(self, "_append_room"))
	Signals.connect("teleport", Callable(self, "_teleport"))
	$player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _append_room(address: Vector2i, room: Node2D):
	if address not in addresses:
		addresses.append(address)
		if address.x < min_x:
			min_x = address.x
			for i in $Rooms.get_children():
				i.position.x += width
		if address.y < min_y:
			min_y = address.y
			for i in $Rooms.get_children():
				i.position.y += height
		$Rooms.add_child(load(room_scene).instantiate())
		$Rooms.get_child(-1).set_room(room)
		$Rooms.get_child(-1).position.y = (min_y * height * -1) + address.y * height
		$Rooms.get_child(-1).position.x = (min_x * width * -1) + address.x * width
		$player.position.y = (min_y * height * -1) + address.y * height + 30
		$player.position.x = (min_x * width * -1) + address.x * width + 45


func _teleport(coord: Vector2i, address: Vector2i):
	current_pos = address
	$player.position.y = (min_y * height * -1) + address.y * height + 30
	$player.position.x = (min_x * width * -1) + address.x * width + 45
	
