extends Node2D
@onready var player_scene = $"../../../../../../Player"
@onready var animation = $AnimatedSprite2D
var start_coord: Vector2i


func _ready() -> void:
	$spawn.wait_time = randf_range(0.5, 1.5)
	$spawn.start()
	var rand_coord = Vector2(randi_range(2, 23), randi_range(2, 13))
	position = rand_coord * 32 - Vector2(428, 4)
	
	
func _process(delta: float) -> void: 
	if animation.frame > 4 and $Area2D.overlaps_area(player_scene.get_child(-3)) \
	   and animation.frame < 10 and $Area2D.overlaps_body(player_scene):
		player_scene.take_damage()


func _on_spawn_timeout() -> void:
	animation.play()
	$AudioStreamPlayer.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "default":
		$"..".remove_child(self)
		self.queue_free()
