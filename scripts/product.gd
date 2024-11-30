extends Node2D
const prize_scene = "res://scenes/rooms/obj/thing.tscn"
const vase_scene = "res://scenes/rooms/obj/vase.tscn"
const chest_scene = "res://scenes/rooms/obj/chest.tscn"

var price = 99
var index = 0
var player_interact_area = false
var is_life = true
const type = ["arrow", "potion"]
var purchased = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect("interact", Callable(self, "_on_interact"))
	var thing
	thing = load(prize_scene).instantiate()
	$"../Things".add_child(thing)
	$"../Things".get_child(-1).position = position - $"..".pos - Vector2(5, 5)
	$"../Things".get_child(-1).it_is_product()
	index = len($"../Things".get_children()) - 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Label.text == "99":
		if price > 0:
			price = $"../Things".get_child(index).type + 1 * 4
		$Label.text = str(price)


func _on_interact():
	if player_interact_area and is_life:
		if $"../../../Player".coins >= price:
			is_life = false
			$"../../../Player".coins -= price
			hide()
			remove_child($CollisionShape2D)
			$Area2D.collision_layer = 0
			$Area2D.collision_mask = 0
			$Bubble5.hide()
			$Label.hide()
			$"../../../CanvasLayer/Label".text = ""
			Signals.emit_signal("message", "Вы купили предмет")
			Signals.emit_signal("statistic", 1, price)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "InteractArea":
		player_interact_area = true
		$"../../../CanvasLayer/Label".text = 'Для покупки, нажмите "E"'


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "InteractArea":
		player_interact_area = false
		$"../../../CanvasLayer/Label".text = ""
