extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("hello")
	pass
	#if not $rooms.start_generate:
		#$CanvasLayer/potions_count.text = str($Player.potions)
		#$CanvasLayer/coins_count.text = str($Player.coins)
		#$CanvasLayer/arrows_count.text = str($Player.arrows)


func paused():
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		for i in get_children():
			i.hide()
	else:
		for i in get_children():
			i.show()
