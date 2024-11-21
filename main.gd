extends Node2D
var start_game = false
var button_press = false


func _ready() -> void:
	Signals.connect("menu_interact", Callable(self, "_on_interact"))
	Signals.connect("death", Callable(self, "_end_game"))


func _process(delta: float) -> void:
	if start_game and Input.is_action_just_pressed(&"esc") and not button_press:
		button_press = true
		if len(get_children()) > 1:
			remove_child(get_children()[-1])
			get_children()[0].paused()
		else:
			add_child(load("res://menu.tscn").instantiate())
			get_children()[-1].set_names("Продолжить", "Выйти в главное меню")
			get_children()[-1].set_label("Пауза")
			get_children()[0].paused()
		button_press = false


func _on_interact(exit_button: bool):
	if not button_press:
		button_press = true
		if not start_game:
			if exit_button:
				get_tree().quit()
			else:
				remove_child(get_children()[0])
				add_child(load("res://dungeon.tscn").instantiate())
				start_game = true
		else:
			if not exit_button:
				remove_child(get_children()[-1])
				get_children()[0].paused()
			else:
				remove_child(get_children()[-1])
				get_children()[0].paused()
				remove_child(get_children()[-1])
				add_child(load("res://menu.tscn").instantiate())
				start_game = false
		button_press = false


func _end_game():
	start_game = false
	remove_child(get_children()[-1])
	add_child(load("res://menu.tscn").instantiate())
	get_children()[-1].set_names("Начать заново", "Выйти из игры")
	get_children()[-1].set_label("Вы погибли!")
