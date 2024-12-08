extends Node2D
var bosses = ["res://scenes/bosses/boss1.tscn", "res://scenes/bosses/boss2.tscn"]
@onready var animation = $"../Node2D/AnimationPlayer"


func _ready() -> void:
	var boss_idx = randi_range(0, 1)
	add_child(load(bosses[boss_idx]).instantiate())
	match boss_idx:
		0: $"../Node2D/AudioStreamPlayer".stream = load("res://music/02 - DavidKBD - Belmont Chronicles Pack - The Mystic Forest.ogg")
		1: $"../Node2D/AudioStreamPlayer".stream = load("res://music/04 - DavidKBD - Belmont Chronicles Pack - Awakening After the War.ogg")
	$"../Node2D/AudioStreamPlayer".play()
	animation.play("start")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start": get_child(-1).state = 1
	if anim_name == "end":
		$"../../../AnimationPlayer".play("death")
		$"../../../CanvasLayer/death_text".set_text("Вы справились!")
