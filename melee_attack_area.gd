extends Node2D

@onready var animation = $MeleeAttackArea/AnimatedSprite2D
@onready var attackArea = $MeleeAttackArea


func _ready() -> void:
	attackArea.hide()
	attackArea.collision_layer = 0
	attackArea.collision_mask = 0


func _process(delta: float) -> void:
	if Input.is_action_pressed(&"attack") and not $"..".damage:
		animation.play()
		attackArea.show()
		attackArea.collision_layer = 4
		attackArea.collision_mask = 4
		await animation.animation_finished
		attackArea.hide()
		attackArea.collision_layer = 0
		attackArea.collision_mask = 0
		animation.stop()
