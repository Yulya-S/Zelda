extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func hide_prize():
	$"../".taken = true
	collision_layer = 0
	collision_mask = 0

func type():
	return $"../".type
