extends Control


# продолжить игру
func _on_return_button_down() -> void:
	$"../..".state = $"../..".states.PLAING
	get_tree().paused = false
	hide()


# Выйти в главное меню
func _on_main_menu_button_down() -> void:
	$"../../../".add_child(load("res://scenes/interface/menu.tscn").instantiate())
	$"../../../".remove_child($"../../")
	$"../../".queue_free()
