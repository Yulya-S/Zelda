extends CharacterBody2D
@export var interface_scene: Node2D = null 
@onready var animation = $AnimatedSprite2D
@onready var fires = $Fires
@onready var attack_zone = $attack_zone
var arrow_scene = load("res://scenes/persons/arrow.tscn")
var interact_object

var room_address: Vector2i = Vector2i(0, 0)  
var coins: int = 0
var potions: int = 0
var arrows: int = 0
var HP: int = 0
var SPEED: float = 250.0

enum states { STOP, WALK, RUN, ATTACK }
enum rotates { left, right, up, down }
var state: states = states.STOP
var rotate: rotates = rotates.down
var get_up: bool = false


func _ready():
	HP = interface_scene.get_child(0).max_value
	Signals.connect("teleport", Callable(self, "_teleport"))
	animation.play()
	set_obj_count()
	

func _input(event: InputEvent) -> void:
	if state != states.ATTACK:
		if event.is_action_pressed("attack"): _change_state(states.ATTACK) # Обработка ближней аттаки
		elif event.is_action_pressed("hill") and potions > 0 \
			 and HP < interface_scene.get_child(0).max_value: # обработка лечения
			potions -= 1
			HP = 6 if HP + 3 > 6 else HP + 3
			interface_scene.get_child(0).value = HP
			set_obj_count()
			Signals.emit_signal("statistic", 0)
		elif event.is_action_pressed("fire") and arrows > 0: # обработка дальней аттаки
			arrows -= 1
			fires.add_child(arrow_scene.instantiate())
			fires.get_child(-1).set_start_pos(position, rotate)
			set_obj_count()
			Signals.emit_signal("statistic", 2)


func _physics_process(delta: float) -> void:
	if interact_object and not interact_object.overlaps_player():
		interface_scene.get_child(-4).set_text("")
		interact_object = null
	
	if HP <= 0:
		get_tree().paused = true
		$"../AnimationPlayer".play("death")
		
	# обработчик клавиши ускорения
	if Input.is_action_pressed("run") and state == states.WALK: _change_state(states.RUN)
	elif Input.is_action_just_released("run") and state == states.RUN: _change_state(states.WALK)
		
	# обработка движения вверх и вниз
	var direction_y = Input.get_axis("move_up", "move_down")
	if direction_y:
		velocity.y = direction_y * SPEED
		if state == states.STOP: _change_state(states.WALK)
	else: velocity.y = move_toward(velocity.y, 0, SPEED)
		
	# обработка движения влево и право
	var direction_x = Input.get_axis("move_left", "move_right")
	if direction_x:
		velocity.x = direction_x * SPEED
		if state == states.STOP: _change_state(states.WALK)
	else: velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# обработка поворота и остановки
	if velocity.x == 0 and velocity.y == 0 and state != states.ATTACK:
		_change_state(states.STOP)
	elif velocity.x != 0:
		if velocity.x > 0: _change_rotate(rotates.right)
		else: _change_rotate(rotates.left)
	elif velocity.y != 0:
		if velocity.y > 0: _change_rotate(rotates.down)
		else: _change_rotate(rotates.up)
	move_and_slide()
	

func take_damage():
	if not get_up:
		get_up = true
		$AnimationPlayer.play("damage")
		HP -= 1
		interface_scene.get_child(0).value = HP


# изменение текста счетчиков предметов
func set_obj_count():
	interface_scene.get_child(-1).set_text(str(arrows))
	interface_scene.get_child(-2).set_text(str(coins))
	interface_scene.get_child(-3).set_text(str(potions))
	

func set_interact_text(text: String, body):
	interface_scene.get_child(-4).set_text("Нажмите Е, " + text)
	interact_object = body


# Изменение состояний игрока
func _change_state(new_state: states):
	if state == new_state or state == states.ATTACK:
		return
	state = new_state
	match state:
		states.STOP: animation.play("stop_" + str(rotates.keys()[int(rotate)]))
		states.RUN: SPEED = 400.0
		states.WALK: SPEED = 250.0
		states.ATTACK:
			attack_zone.get_child(0).play("default")
			animation.play("attack_" + str(rotates.keys()[int(rotate)]))


# Изменение поворота игрока
func _change_rotate(new_rotate):
	if state != states.ATTACK:
		rotate = new_rotate
		animation.play("move_" + str(rotates.keys()[int(rotate)]))
		match rotate:
			rotates.left: attack_zone.rotation_degrees = 0
			rotates.right: attack_zone.rotation_degrees = 180
			rotates.up: attack_zone.rotation_degrees = 90
			rotates.down: attack_zone.rotation_degrees = 270


# Перенос при переходе между комнатами
func _teleport(coord: Vector2i, address: Vector2i):
	position = coord
	room_address = address
		

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "damage": get_up = false


# обработка окончания удара
func _attack_animation_finished() -> void:
	if str(attack_zone.get_child(0).animation) == "default":
		state = states.STOP
