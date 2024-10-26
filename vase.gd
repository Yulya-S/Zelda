extends StaticBody2D

@onready var animation = $AnimatedSprite2D

var hp = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect("attack", Callable(self, "_taking_damage"))
	animation.animation = &"" + str(randi_range(1, 5))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _taking_damage(damage: int):
	if hp > 0 and hp - damage <= 0:
		hp -= damage
		animation.play()
		await animation.animation_looped
		animation.stop()
		animation.frame = animation.sprite_frames.get_frame_count(animation.animation) - 1
		collision_layer = 0
		collision_mask = 0
