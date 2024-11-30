extends Node2D
@onready var rooms_scene = $"../../Rooms"
@onready var text_scene = $loading_stage

enum stages {
	LOAD_ROOM = 1,
	DUNGEON = 2,
	ADD_DOORS = 3,
	START = 4
}
var stage: stages = stages.LOAD_ROOM
var room_count: int = 10
var idx: int = 0


func _ready() -> void:
	$AnimationPlayer.play("loading")
	$loading_stage.text = "загружаем комнаты"
	get_tree().paused = true


func _process(delta: float) -> void:
	match stage:
		stages.LOAD_ROOM:
			if rooms_scene.load_rooms(): set_next_stage()
		stages.DUNGEON:
			rooms_scene.generate_room()
			idx += 1
			if idx >= room_count: set_next_stage()
		stages.ADD_DOORS:
			if not rooms_scene.set_doors(idx) or idx >= room_count: set_next_stage()
			idx += 1
		stages.START:
			rooms_scene.get_child(0).show_room()
			$"../Pause".hide()
			$"../map".hide()
			get_tree().paused = false
			$"..".remove_child(self)
			self.queue_free()

	
# переход на следующую стадию загрузки
func set_next_stage():
	stage = stages[stages.keys()[int(stage)]]
	idx = 0
	match stage:
		stages.DUNGEON: text_scene.text = "создаем структуру подземелья"
		stages.ADD_DOORS: text_scene.text = "добавляем переходы между комнатами"
		stages.START: text_scene.text = "запускаем игру"


# запуск повторения анимации после её окончания
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "loading" and stage != stages.START:
		$AnimationPlayer.play("loading")
