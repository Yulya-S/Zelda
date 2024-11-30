extends StaticBody2D
@onready var animation = $AnimatedSprite2D
@onready var player_scene = $"../../../../Player"
const prize_scene = "res://scenes/rooms/obj/thing.tscn"
var HP: int = 1


func _ready() -> void:
	animation.animation = str(randi_range(1, 5))


func _process(delta: float) -> void:
	if overlaps_player_attack(): take_damage()
		

# перемещаем вазу в нужное место во время её создания
func set_pos(coord: Vector2i):
	position = coord


# проверка пытается ли игрок совершить удар и попадет ли по вазе
func overlaps_player_attack():
	return player_scene.state == 3 and $hit_zone.overlaps_area(player_scene.get_child(-3))


# функция получения урона вазой
func take_damage():
	if HP  > 0:
		HP = 0
		animation.play()
		collision_layer = 0
		collision_mask = 0
		Signals.emit_signal("statistic", 3)
		if bool(randi_range(0, 1)):
			var thing_path = $"../../things"
			thing_path.add_child(load(prize_scene).instantiate())
			thing_path.get_children()[-1].position = position
			

# обработка поподания в вазу дальней атаки
func _on_hit_zone_area_entered(area: Area2D) -> void:
	if area.name == "fire" and area.get_parent().get_parent().get_parent().name == "Player":
		take_damage()
