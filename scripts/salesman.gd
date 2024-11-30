extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play(&"stand" + str(randi_range(1, 2)))
	if bool(randi_range(0, 1)):
		$"../Product".price = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
