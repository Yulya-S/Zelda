extends Node2D
var bosses = ["res://scenes/bosses/boss1.tscn", "res://scenes/bosses/boss2.tscn"]
@onready var animation = $"../Node2D/AnimationPlayer"


func _ready() -> void:
	add_child(load(bosses[randi_range(0, 1)]).instantiate())
	animation.play("start")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start": get_child(-1).state = 1
	if anim_name == "end":
		$"../../../AnimationPlayer".play("death")
		$"../../../CanvasLayer/death_text".set_text("Вы справились!")
