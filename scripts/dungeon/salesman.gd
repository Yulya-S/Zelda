extends StaticBody2D


func _ready() -> void:
	$AnimatedSprite2D.play("stand" + str(randi_range(1, 2)))
	if bool(randi_range(0, 1)): $"../goods/Product".price = 0


func _process(delta: float) -> void:
	pass
