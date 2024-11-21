extends Node2D
@export var text = ""
@export var gold = true
var mouse_enter = false


func set_label(button_name):
	$Label.text = str(button_name)


func _ready() -> void:
	$Label.text = str(text)
	if gold:
		$AnimatedSprite2D.animation = &"start"
	else:
		$AnimatedSprite2D.animation = &"exit"
	$AnimatedSprite2D.play()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(&"mouse_press") and mouse_enter:
		Signals.emit_signal("menu_interact", not gold)


func _on_area_2d_mouse_entered() -> void:
	mouse_enter = true
	if gold:
		$AnimatedSprite2D.animation = &"start_open"
	else:
		$AnimatedSprite2D.animation = &"exit_open"
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.frame = $AnimatedSprite2D.sprite_frames.get_frame_count($AnimatedSprite2D.animation) - 1


func _on_area_2d_mouse_exited() -> void:
	if gold:
		$AnimatedSprite2D.animation = &"start_open"
	else:
		$AnimatedSprite2D.animation = &"exit_open"
	$AnimatedSprite2D.play_backwards()
	mouse_enter = false
	await $AnimatedSprite2D.animation_finished
	if gold:
		$AnimatedSprite2D.animation = &"start"
	else:
		$AnimatedSprite2D.animation = &"exit"
	$AnimatedSprite2D.play()
