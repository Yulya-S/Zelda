extends Node2D
enum rotates { LEFT, RIGHT, UP, DOWN }
var start_coord: Vector2i
var turn: int = 0
const SPEED: int = 5


func _ready() -> void:
	$lifeTime.start()
	$AnimatedSprite2D.play()
	
	
func _process(delta: float) -> void:
	match turn:
		0: start_coord.x -= SPEED
		1: start_coord.x += SPEED
		2: start_coord.y -= SPEED
		3: start_coord.y += SPEED
	position = start_coord - Vector2i($"../../".position)
	

# Установление стартовой позиции и направления полета
func set_start_pos(coord: Vector2i, rotate: int):
	turn = rotates[rotates.keys()[int(rotate)]]
	start_coord = Vector2i(coord)


# обработка оканчания жизни стрелы
func _on_life_time_timeout() -> void:
	$"..".remove_child(self)
	self.queue_free()
