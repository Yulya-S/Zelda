extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Camera2D.make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_names(start_name, exit_name):
	$start_continue.set_label(start_name)
	$exit_main_menu.set_label(exit_name)


func set_label(text):
	$Label.text = text
