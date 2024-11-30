extends Node2D
var dungeone_scene = preload("res://scenes/dungeon.tscn")
var menu_scene = preload("res://scenes/interface/menu.tscn")
@export var map_scene = preload("res://scenes/map/map.tscn")

enum state { MENU, PLAING, PAUSE, MAP }

var start_game = false
var button_press = false
var mod = state.MENU


func _ready() -> void:
	#get_tree().paused = true
	Signals.connect("menu_interact", Callable(self, "_on_interact"))
	Signals.connect("death", Callable(self, "_end_game"))


func _process(delta: float) -> void:
	pass
	

func _input(event):
	if mod != state.MENU:
		if event.is_action_pressed("esc"):
			match mod:
				state.PLAING:
					add_child(menu_scene.instantiate())
					get_children()[-1].set_names("Продолжить", "Выйти в главное меню")
					get_children()[-1].set_label("Пауза")
					mod = state.PAUSE
				state.MAP:
					$dungeon/Player/Camera2D.make_current()
					$map.hide()
					mod = state.PLAING
				state.PAUSE:
					$menu.queue_free()
					mod = state.PLAING
			$dungeon.paused()
		elif event.is_action_pressed("map"):
			if mod == state.PLAING:
				$map/Camera2D.make_current()
				$map.show()
				$dungeon.paused()
				mod = state.MAP
			elif mod == state.MAP:
				$dungeon/Player/Camera2D.make_current()
				$map.hide()
				$dungeon.paused()
				mod = state.PLAING


func _on_interact(exit_button: bool):
	if not button_press:
		button_press = true
		if mod == state.MENU:
			if exit_button:
				get_tree().quit()
			else:
				get_tree().paused = true
				remove_child($menu)
				add_child(dungeone_scene.instantiate())
				mod = state.PLAING
		else:
			if not exit_button:
				remove_child($menu)
				$dungeon.paused()
				mod = state.PLAING
			else:
				get_tree().paused = true
				remove_child($map)
				remove_child($dungeon)
				add_child(menu_scene.instantiate())
				mod = state.MENU
		button_press = false


func _end_game():
	get_tree().paused = true
	mod = state.MENU
	$dungeon.paused()
	remove_child($map)
	remove_child($dungeon)
	add_child(menu_scene.instantiate())
	$menu.set_names("Начать заново", "Выйти из игры")
	$menu.set_label("Вы погибли!")
