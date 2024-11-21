extends StaticBody2D

@onready var animation = $AnimatedSprite2D

var hp = 1

func _ready() -> void:
	animation.animation = &"" + str(randi_range(1, 5))


func _process(delta: float) -> void:
	pass
	

func _on_hit_box_area_area_entered(area: Area2D) -> void:
	if area.name in ["MeleeAttackArea", "Fire"]:
		if hp > 0:
			hp -= 10
			if hp - 10 <= 0:
				collision_layer = 0
				collision_mask = 0
				animation.play()


func set_pos(coord: Vector2i):
	position = coord
