extends Node2D
enum objects { arrow, potion, coin }
var type = null

var player: Node2D
var is_create = false
var shop = false


func _ready() -> void:
	if type == null: set_type(randi_range(0, 2))
	$Timer.wait_time = randf_range(0.5, 1.0)
	$Timer.start()
	

func set_type(idx: int):
	type = objects[objects.keys()[idx]]
	$"AnimatedSprite2D".play(objects.keys()[type])


func _process(delta: float) -> void:
	if player and $interact_zone.overlaps_area(player.get_child(-1)) \
	   and $interact_zone.overlaps_body(player) and is_create:
		take()


func take():
	match type:
		0:
			player.arrows += 1
			Signals.emit_signal("new_message", "Вы подобрали стрелу")
		1:
			player.potions += 1
			Signals.emit_signal("new_message", "Вы подобрали зелье лечения")
		2:
			player.coins += 1
			Signals.emit_signal("new_message", "Вы подобрали монету")
	player.set_obj_count()
	$"..".remove_child(self)
	self.queue_free()


# обработка подбора предмета игроком
func _on_interact_zone_area_entered(area: Area2D) -> void:
	if area.name == "hit_zone" and area.get_parent().name == "Player":
		if not player: player = area.get_parent()
		if is_create: take()


func _on_timer_timeout() -> void:
	$AnimationPlayer.play("spawn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "spawn": is_create = true
