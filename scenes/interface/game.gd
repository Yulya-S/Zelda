extends Node2D
@onready var pause_scene = $CanvasLayer/Pause
@onready var map_scene = $CanvasLayer/map
@onready var messanger_scene = $CanvasLayer/Interface/messenger

enum states { PLAING, PAUSE, MAP }
var state = states.PLAING


func _ready() -> void:
	Signals.connect("new_message", Callable(self, "_create_message"))


func _process(delta: float) -> void:
	# отображение значение fps
	$CanvasLayer/Interface/fps.set_text("FPS " + str(Engine.get_frames_per_second()))


func  _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if state == states.PLAING:
			pause_scene.show()
			_change_state(states.PAUSE)
		else:
			pause_scene.hide()
			map_scene.hide()
			_change_state(states.PLAING)
	elif event.is_action_pressed("map"):
		if state == states.PLAING:
			map_scene.show()
			_change_state(states.MAP)
		elif state == states.MAP:
			map_scene.hide()
			_change_state(states.PLAING)


# изменение состояния игры
func _change_state(new_state: states):
	get_tree().paused = not get_tree().paused
	state = new_state
	

# добавление сообщения о событии
func _create_message(text: String):
	messanger_scene.add_child(load("res://scenes/interface/message.tscn").instantiate())
	messanger_scene.get_child(-1).set_text(text)
	for i in range(len(messanger_scene.get_children()) - 1):
		messanger_scene.get_child(i).position.y += 20


# обработка оканчания окна смерти
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		$"..".add_child(load("res://scenes/interface/menu.tscn").instantiate())
		$"..".remove_child(self)
		self.queue_free()
