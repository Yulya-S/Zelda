extends Node2D
var end = false


func _ready() -> void:
	$AnimationPlayer.play("hide_text")


# замена текста
func set_text(value: String):
	$Label.set_text(value)


# Удаление сообщения после окончания анимации
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hide_text":
		$"..".remove_child(self)
		self.queue_free()
