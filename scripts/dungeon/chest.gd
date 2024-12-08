extends StaticBody2D
const prize_scene = "res://scenes/rooms/obj/thing.tscn"
@onready var player_scene = $"../../../../Player"
@onready var animation = $chestAnimation
@onready var things_scene = $"../../things"

var player_in_collision = false
var open = false
var pos: Vector2i


func _ready() -> void:
	animation.play()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and overlaps_player():
		Signals.emit_signal("statistic", 4)
		animation.play("open")
		$AudioStreamPlayer.play()


func _process(delta: float) -> void:
	if overlaps_player(): player_scene.set_interact_text("для открытия", self)
			

func overlaps_player():
	return not open and $InteractArea.overlaps_body(player_scene) \
		   and $InteractArea.overlaps_area(player_scene.get_child(-1))


# перемещаем сундук в нужное место во время её создания
func set_pos(coord: Vector2i):
	position = coord


func _on_chest_animation_animation_finished() -> void:
	if animation.animation == "open" and not open:
		open = true
		var things = load(prize_scene)
		var room_pos = Vector2($"../../".position)
		for i in range(randi_range(3, 6)):
			var thing = things.instantiate()
			thing.position = position - room_pos 
			thing.position.x += randi_range(-50, 50)
			thing.position.y += 25
			things_scene.add_child(thing)
		$AnimationPlayer.play("close")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "close":
		$"..".remove_child(self)
		self.queue_free()
