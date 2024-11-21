extends Node2D
var fire = load("res://Fire.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed(&"fire") and not $"..".damage and $"..".arrows > 0:
		add_child(fire.instantiate())
		get_children()[-1].start_coord = $"..".position
		if $"../AnimatedSprite2D".animation in [&"up", &"stop_top"]:
			get_children()[-1].turn = 0
		elif $"../AnimatedSprite2D".animation in [&"right", &"stop_right"]:
			get_children()[-1].turn = 1
		elif $"../AnimatedSprite2D".animation in [&"down", &"stop_down"]:
			get_children()[-1].turn = 2
		elif $"../AnimatedSprite2D".animation in [&"left", &"stop_left"]:
			get_children()[-1].turn = 3
		$"..".arrows -= 1

	for i in get_children():
		i.set_coord($"..".position)
		if i.is_death:
			remove_child(i)
