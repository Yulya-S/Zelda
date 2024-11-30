extends StaticBody2D
const prize_scene = "res://scenes/rooms/obj/prize.tscn"
@onready var animation = $chestAnimation

var player_in_collision = false
var open = false

func _ready() -> void:
	Signals.connect("interact", Callable(self, "_on_interact"))
	animation.play()


func _on_interact():
	if player_in_collision and not open:
		open = true
		animation.play(&"open")
		await animation.animation_looped
		animation.stop()
		animation.frame = animation.sprite_frames.get_frame_count(animation.animation) - 1
		$"../../../CanvasLayer/Label".text = ""
		Signals.emit_signal("statistic", 4)
		
		var things = load(prize_scene)
		var coords = []
		var room_pos = Vector2($"..".pos)
		for i in range(randi_range(3, 6)):
			$"../Things".add_child(things.instantiate())
			$"../Things".get_children()[-1].position = position - room_pos 
			$"../Things".get_children()[-1].position.x += randi_range(-50, 50)
			$"../Things".get_children()[-1].position.y += 50
			while ($"../Things".get_children()[-1].position in coords):
				$"../Things".get_children()[-1].position = position - room_pos
				$"../Things".get_children()[-1].position.x += randi_range(-50, 50)
				$"../Things".get_children()[-1].position.y += 50
			coords.append($"../Things".get_children()[-1].position)


func _on_interact_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not open:
		player_in_collision = true
		$"../../../CanvasLayer/Label".text = 'Нажмите "E" что бы открыть'


func _on_interact_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_collision = false
		$"../../../CanvasLayer/Label".text = ""
