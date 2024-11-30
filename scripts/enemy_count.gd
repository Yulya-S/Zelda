extends Label
var all_enemys = 0
var death_enemys = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect("enemy_death", Callable(self, "_enemy_death"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if all_enemys == 0:
		#for i in $"../../../dungeon/rooms".get_children():
			#for l in i.get_child(4).get_children():
				#if l is CharacterBody2D:
					#all_enemys += 1
		#text = str(all_enemys - death_enemys)


func _enemy_death():
	death_enemys += 1
	text = str(all_enemys - death_enemys)
	if all_enemys - death_enemys == 0:
		text = ""
		$"../Label2".text = "Комната босса открыта"
