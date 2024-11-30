extends Node2D
@export var gold = true
@export var text = "Нажми меня"
@export var mouse_enter = false


func _ready() -> void:
	$Label.text = text
	$AnimatedSprite2D.play("start" if gold else "exit")


# анимация наведения курсора
func _on_area_2d_mouse_entered() -> void:
	mouse_enter = true
	$AnimatedSprite2D.play("start_open" if gold else "exit_open")


# анимация отвода курсора
func _on_area_2d_mouse_exited() -> void:
	mouse_enter = false
	$AnimatedSprite2D.play_backwards("start_open" if gold else "exit_open")


# обработка окончания анимаций
func _on_animated_sprite_2d_animation_finished() -> void:
	if str($AnimatedSprite2D.animation) == ("start_open" if gold else "exit_open"):
		if not mouse_enter: $AnimatedSprite2D.play("start"  if gold else "exit")
