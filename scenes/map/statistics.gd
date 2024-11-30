extends Node2D
var statistic = [0, 0, 0, 0, 0]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect("statistic", Callable(self, "_change"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _change(idx: int, count: int = 1):
	statistic[idx] += count
	var text = ""
	for i in statistic:
		text += str(i) + "\n"
	
	$values.text = text
