extends CharacterBody2D
@onready var room = $".."
@onready var player_scene = $"../../../../Player"
@onready var animation = $AnimatedSprite2D
@onready var attack_scene = $attack_zone/AnimatedSprite2D

enum states {STOP, AGGRESSION, ATTACK, DEATH}
enum colors { black, red }
var state: states = states.STOP
var color: colors

var HP: int = 2
const SPEED: float = 100.0
var get_up: bool = false


func _ready() -> void:
	color = colors[colors.keys()[randi_range(0, len(colors.keys()) - 1)]]
	$AnimatedSprite2D.play("UpDown_" + str(colors.keys()[color]))


func _physics_process(delta: float) -> void:
	if HP <= 0:
		_change_state(states.DEATH)
		return
	if state == states.AGGRESSION:
		var direction = (player_scene.position - (position + room.position)).normalized()
		velocity = direction * SPEED
		if overlaps_player_hit_zone($attack_zone): _change_state(states.ATTACK)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		if state == states.ATTACK and attack_scene.frame > 4 \
		   and attack_scene.frame < 11 and overlaps_player_hit_zone($attack_zone):
			player_scene.take_damage()
	if overlaps_player_attack(): take_damage()
	move_and_slide()
	

# изменение состояния врага
func _change_state(new_state: states):
	if state == states.DEATH: return
	state = new_state
	match state:
		states.ATTACK:
			animation.play("Attack_" + str(colors.keys()[color]))
			attack_scene.play("default")
		states.DEATH:
			animation.play("Dead_" + str(colors.keys()[color]))
			collision_layer = 0
			collision_mask = 0


# изменение координат врага при его создании
func set_pos(coord: Vector2i): position = coord
	

# фукция получения урона
func take_damage():
	if not get_up:
		get_up = true
		HP -= 1
		$AnimationPlayer.play("damage")


# проверка находится ли ещё игрок в определенной зоне
func overlaps_player_hit_zone(zone: Area2D):
	return zone.overlaps_body(player_scene) and zone.overlaps_area(player_scene.get_child(-1))		
	
# проверка пытается ли игрок совершить удар и попадет ли по врагу
func overlaps_player_attack():
	return player_scene.state == 3 and $hit_zone.overlaps_area(player_scene.get_child(-3))		


# Обработка попадания игрока в зону видимости
func _on_visibility_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player"and state != states.ATTACK: _change_state(states.AGGRESSION)

# Обработка выхода игрока из зоны видимости
func _on_visibility_zone_body_exited(body: Node2D) -> void:
	if body.name == "Player" and state != states.ATTACK: _change_state(states.STOP)


# обработка получения урона от дальней атаки
func _on_hit_zone_area_entered(area: Area2D) -> void:
	if state == states.DEATH: return
	if area.name == "fire" and area.get_parent().get_parent().get_parent().name == "Player":
		take_damage()
		

# обработка окончания анимации атаки и перевод врага в новое состояние
func _on_animated_sprite_2d_animation_finished() -> void:
	if str(attack_scene.animation) == "default":
		if overlaps_player_hit_zone($attack_zone): _change_state(states.ATTACK)
		elif overlaps_player_hit_zone($visibility_zone): _change_state(states.AGGRESSION)
		else: _change_state(states.STOP)


# обработка оканчания анимации получения урона
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "damage": get_up = false
