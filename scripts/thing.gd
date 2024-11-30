extends Node2D
@export var type = 0
@export var taken = false
@export var shop = false
enum objects { arrow, coin, potion }


func _ready() -> void:
	type = randi_range(0, 2)
	$"AnimatedSprite2D".play(objects.keys()[type])


func _process(delta: float) -> void:
	if not $"Timer".is_stopped():
		$"AnimatedSprite2D".modulate.a = 1 - $"Timer".time_left
	if shop and type == 1:
		while type == 1:
			type = randi_range(0, 2)
		$"AnimatedSprite2D".play(objects.keys()[type])


func it_is_product():
	shop = true


# обработка подбора предмета игроком
func _on_interact_zone_area_entered(area: Area2D) -> void:
	if area.name == "hit_zone" and area.get_parent().name == "Player":
		area.get_parent().add_thing(type)
		$"..".remove_child(self)
		self.queue_free()
