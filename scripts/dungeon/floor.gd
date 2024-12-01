extends TileMapLayer


func _ready() -> void:
	for i in range(randi_range(50, 100)):
		var tile_coord = Vector2i(randi_range(4, 8), randi_range(40, 47))
		set_cell(Vector2i(randi_range(0, 25), randi_range(0, 15)), 0, tile_coord)
