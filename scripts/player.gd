extends CharacterBody2D

@onready var meel_attack = $Node2D
const SPEED = 400.0

const meal_damege = 10


func _ready():
	Signals.connect("teleport", Callable(self, "_on_interact"))
	$AnimatedSprite2D.play()


func _physics_process(delta: float) -> void:
	var direction_x = Input.get_axis(&"move_left", &"move_right")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		

	var direction_y = Input.get_axis(&"move_up", &"move_down")
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if Input.is_action_pressed(&"interact"):
		Signals.emit_signal("interact")

	if velocity.y == 0 && velocity.x == 0:
		if Input.is_action_just_released(&"move_up"):
			$AnimatedSprite2D.animation = &"stop_top"
		elif Input.is_action_just_released(&"move_down"):
			$AnimatedSprite2D.animation = &"stop_down"
		elif Input.is_action_just_released(&"move_left"):
			$AnimatedSprite2D.animation = &"stop_left"
		elif Input.is_action_just_released(&"move_right"):
			$AnimatedSprite2D.animation = &"stop_right"

	if velocity.x != 0:
		if velocity.x > 0:
			$AnimatedSprite2D.animation = &"right"
			meel_attack.rotation_degrees = 240
		else:
			$AnimatedSprite2D.animation = &"left"
			meel_attack.rotation_degrees = 0
	elif velocity.y != 0:
		if velocity.y < 0:
			$AnimatedSprite2D.animation = &"up"
			meel_attack.rotation_degrees = 120
		else:
			$AnimatedSprite2D.animation = &"down"
			meel_attack.rotation_degrees = 320

	move_and_slide()


func _on_interact(coord: Vector2i):
	position = coord
