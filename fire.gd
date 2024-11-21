extends Node2D
@export var is_death = false
@export var start_coord: Vector2i
var turn = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$lifeTime.start()
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_life_time_timeout() -> void:
	is_death = true


func set_coord(coord: Vector2i):
	if turn == 0:
		start_coord.y -= 5
	elif turn == 1:
		start_coord.x += 5
	elif turn == 2:
		start_coord.y += 5
	elif turn == 3:
		start_coord.x -= 5
	position = start_coord - coord
