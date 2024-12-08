extends CharacterBody2D
@onready var player_scene = $"../../../../../../Player"
var start_coord: Vector2i
var SPEED: float = 200.0


func _ready() -> void:
	$AnimatedSprite2D.hide()
	
	
func _process(delta: float) -> void:
	if $lifeTime.time_left != $lifeTime.wait_time:
		var direction = (player_scene.position - position - $"../".position).normalized()
		velocity = direction * SPEED
		move_and_slide()
	
	
func set_stawn_time(time: float):
	$spawn.wait_time = time
	$spawn.start()
	SPEED = 100 * (1 / time)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "hit_zone" and area.get_parent() == player_scene:
		player_scene.take_damage()
		$"..".remove_child(self)
		self.queue_free()
		
		
# обработка оканчания жизни стрелы
func _on_life_time_timeout() -> void:
	$"..".remove_child(self)
	self.queue_free()


func _on_spawn_timeout() -> void:
	$lifeTime.start()
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play()
	$AudioStreamPlayer.play()
