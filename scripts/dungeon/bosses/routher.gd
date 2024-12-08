extends StaticBody2D
@onready var healthBar = $"../CanvasLayer/healthBar"
@onready var player_scene = $"../../../../Player"
@onready var animation = $AnimatedSprite2D
var fire_scene = "res://scenes/bosses/fires/fire3.tscn"

enum states { STOP, AGGRESSION, ATTACK, DEATH }
var state: states = states.STOP
var HP: int = 10
var get_up: bool = false


func _ready() -> void:
	healthBar.max_value = HP
	healthBar.value = HP


func _process(delta: float) -> void:
	if HP <= 0:
		_change_state(states.DEATH)
		return
	if overlaps_player_attack(): take_damage()
	

# изменение состояния босса
func _change_state(new_state: states):
	if state == states.DEATH: return
	state = new_state
	match state:
		states.AGGRESSION: $get_up.start()
		states.ATTACK:
			animation.play("attack")
			for i in range(6):
				$fires.add_child(load(fire_scene).instantiate())
				$fires.get_child(-1).set_stawn_time(0.5 * (i + 1))
		states.DEATH:
			$"../../Node2D/AnimationPlayer".play("end")
			

# проверка пытается ли игрок совершить удар и попадет ли по боссу
func overlaps_player_attack():
	return player_scene.state == 3 and $hit_zone.overlaps_area(player_scene.get_child(-3))	


func take_damage():
	if not get_up:
		get_up = true
		HP -= 1
		healthBar.value -= 1
		$AnimationPlayer.play("damage")


func _on_get_up_timeout() -> void:
	if state != states.DEATH:
		_change_state(states.ATTACK)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "damage": get_up = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "attack":
		animation.play("get_up")
		$get_up.start()
