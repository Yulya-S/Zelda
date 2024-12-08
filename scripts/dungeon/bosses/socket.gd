extends StaticBody2D
@onready var healthBar = $"../CanvasLayer/healthBar"
@onready var player_scene = $"../../../../Player"
@onready var attack2_scene = $attack_zone/AnimatedSprite2D
var fire1_scene = "res://scenes/bosses/fires/fire1.tscn"
var fire2_scene = "res://scenes/bosses/fires/fire2.tscn"

enum states { STOP, AGGRESSION, ATTACK1, ATTACK2, ATTACK3, DEATH }
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
	if state == states.ATTACK2 and attack2_scene.frame > 4 \
	   and attack2_scene.frame < 13 and overlaps_player_hit_zone($attack_zone):
		player_scene.take_damage()
	if overlaps_player_attack(): take_damage()


# изменение состояния босса
func _change_state(new_state: states):
	if state == states.DEATH: return
	state = new_state
	match state:
		states.AGGRESSION: $get_up.start()
		states.ATTACK1:
			$fires.add_child(load(fire1_scene).instantiate())
			$sprites/AnimatedSprite2D.play("attack1")
		states.ATTACK2:
			attack2_scene.play("default")
			$attack_zone/AudioStreamPlayer.play()
			$sprites/AnimatedSprite2D2.play("attack2")
		states.ATTACK3:
			for i in range(randi_range(2, 7)):
				$fires.add_child(load(fire2_scene).instantiate())
			$sprites/AnimatedSprite2D3.play("attack3")
		states.DEATH:
			$"../../Node2D/AnimationPlayer".play("end")
			

# проверка пытается ли игрок совершить удар и попадет ли по боссу
func overlaps_player_attack():
	return player_scene.state == 3 and $hit_zone.overlaps_area(player_scene.get_child(-3))	


# проверка находится ли игрок в определенной зоне
func overlaps_player_hit_zone(zone: Area2D):
	return zone.overlaps_body(player_scene) and zone.overlaps_area(player_scene.get_child(-1))		
	

func take_damage():
	if not get_up:
		get_up = true
		HP -= 1
		healthBar.value -= 1
		$AnimationPlayer.play("damage")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "damage": get_up = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if attack2_scene.animation == "default" and state != states.DEATH:
		_change_state(states.AGGRESSION)


func _on_get_up_timeout() -> void:
	if state != states.DEATH:
		_change_state(states[states.keys()[randi_range(2, 4)]])


func _face1_animation_finished() -> void:
	$sprites/AnimatedSprite2D.play("default")
	$get_up.start()

func _face2_animation_finished() -> void:
	$sprites/AnimatedSprite2D2.play("default")

func _face3_animation_finished() -> void:
	$sprites/AnimatedSprite2D3.play("default")
	$get_up.start()
