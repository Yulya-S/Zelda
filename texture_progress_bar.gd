extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect("attack", Callable(self, "_damage"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _damage():
	if value == 0:
		value = max_value
	value -= 1
	if value == 0:
		Signals.emit_signal("death")
