extends Area2D
@export var type = 0
var objects = ["arrow", "coin", "potion"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	type = randi_range(0, 2)
	$"../AnimatedSprite2D".play(&""+objects[type])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func hide_prize():
	collision_layer = 0
	collision_mask = 0
	$"..".hide()
