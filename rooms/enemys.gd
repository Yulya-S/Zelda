extends Node2D
@export var poses = []


func _ready() -> void:
	pass


func create(enemy_count: int = 0):
	var room = $".."
	var obs = $"../Obstacles"
	var wall = $"../Wall"
	var en = load("res://Enemy.tscn")
	var vase = load("res://vase.tscn")
	var coords = []
	while len(coords) != enemy_count:
		var coord = Vector2i(randi_range(2, 23), randi_range(2, 13))
		if obs.get_cell_source_id(coord) == -1 && wall.get_cell_source_id(coord):
			if coord not in coords:
				coords.append(coord)
				coord = Vector2i(coord.x * 32, coord.y * 32)
				var rnd = randi_range(0, 15)
				if rnd > 7:
					var enemy = en.instantiate()
					enemy.set_pos(coord)
					add_child(enemy)
				else:
					var v = vase.instantiate()
					v.set_pos(coord)
					add_child(v)


func _process(delta: float) -> void:
	pass
