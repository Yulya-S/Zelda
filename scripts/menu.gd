extends Node2D


func _ready() -> void:
	$Camera2D.make_current()
	$AnimationPlayer.play("appearance")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_press"):
		if $exit.mouse_enter: get_tree().quit()
		elif $start.mouse_enter: $AnimationPlayer.play("Disappearance")


# обработка окончаний анимаций
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Disappearance":
		$"..".add_child(load("res://scenes/interface/game.tscn").instantiate())
		$"..".remove_child(self)
		self.queue_free()
