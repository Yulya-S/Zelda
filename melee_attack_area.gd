extends Node2D

@onready var animation = $MeleeAttackArea/AnimatedSprite2D
var collis = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed(&"attack"):
		animation.play()
		if collis:
			Signals.emit_signal("attack", $"..".meal_damege)
		await animation.animation_looped
		animation.stop()
		animation.frame = 0


func _on_melee_attack_area_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		collis = true


func _on_melee_attack_area_body_exited(body: Node2D) -> void:
	collis = false
