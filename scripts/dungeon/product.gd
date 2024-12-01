extends Node2D
const thing_scene = "res://scenes/rooms/obj/thing.tscn"
var price: int = 99
var player: Node2D


func _ready() -> void:
	var thing = load(thing_scene).instantiate()
	thing.position += position
	thing.set_type(randi_range(0, 1))
	price = (thing.type + 1) * 4
	$Label.set_text(str(price))
	$"../../things".add_child(thing)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and overlaps_player():
		if player.coins >= price:
			player.coins -= price
			$"..".remove_child(self)
			self.queue_free()
			Signals.emit_signal("message", "Вы купили предмет")
			Signals.emit_signal("statistic", 1, price)
		

func _process(delta: float) -> void:
	if overlaps_player():
		player.set_interact_text("для покупки", self)
			

func overlaps_player():
	return player and $Area2D.overlaps_body(player) \
		   and $Area2D.overlaps_area(player.get_child(-1))
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not player and area.name == "hit_zone" and area.get_parent().name == "Player":
		player = area.get_parent()
