extends CharacterBody2D

@onready var animation = $chestAnimation
var player_in_collision = false
var open = false

func _ready() -> void:
	Signals.connect("interact", Callable(self, "_on_interact"))
	animation.play()


func _on_interact():
	if player_in_collision:
		animation.play(&"open")
		await animation.animation_looped
		animation.stop()
		animation.frame = animation.sprite_frames.get_frame_count(animation.animation) - 1
		$"../CanvasLayer/Label".text = ""
		open = true


func _on_interact_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not open:
		player_in_collision = true
		$"../CanvasLayer/Label".text = "press E"


func _on_interact_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_collision = false
		$"../CanvasLayer/Label".text = ""
