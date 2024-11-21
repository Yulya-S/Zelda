extends TileMapLayer
var color = randi_range(0, 2)
var tiles = [
	[[1, 34], [1, 35], [1, 36],
	 [2, 34], [2, 35], [2, 36],
	 [3, 34], [3, 35], [3, 36]],
	
	[[16, 34], [16, 35], [16, 36],
	 [17, 34], [17, 35], [17, 36],
	 [18, 34], [18, 35], [18, 36]],
	
	[[31, 34], [31, 35], [31, 36],
	 [32, 34], [32, 35], [32, 36],
	 [33, 34], [33, 35], [33, 36]]
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(0, 50):
		for y in range(0, 30):
			var tile = randi_range(0, len(tiles[color]) - 1)
			set_cell(Vector2i(x, y), 0, Vector2i(tiles[color][tile][0], tiles[color][tile][1]))
	tiles = []
	
	#for i in range(randi_range(50, 100)):
	#	var tile_coord = Vector2i(randi_range(0, 50), randi_range(0, 47))
	#	set_cell(Vector2i(randi_range(0, 25), randi_range(0, 15)), 0, tile_coord)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
