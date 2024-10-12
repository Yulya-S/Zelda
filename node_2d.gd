extends Area2D

signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size
	#hide()


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed(&"move_right"):
		velocity.x += 1
	if Input.is_action_pressed(&"move_left"):
		velocity.x -= 1
	if Input.is_action_pressed(&"move_down"):
		velocity.y += 1
	if Input.is_action_pressed(&"move_up"):
		velocity.y -= 1
	if velocity.y == 0 && velocity.x == 0:
		if Input.is_action_just_released(&"move_up"):
			$AnimatedSprite2D.animation = &"stop_top"
		if Input.is_action_just_released(&"move_down"):
			$AnimatedSprite2D.animation = &"stop_down"
		if Input.is_action_just_released(&"move_left"):
			$AnimatedSprite2D.animation = &"stop_left"
		if Input.is_action_just_released(&"move_right"):
			$AnimatedSprite2D.animation = &"stop_right"

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		if velocity.x > 0:
			$AnimatedSprite2D.animation = &"right"
		else:
			$AnimatedSprite2D.animation = &"left"
	elif velocity.y != 0:
		if velocity.y < 0:
			$AnimatedSprite2D.animation = &"up"
		else:
			$AnimatedSprite2D.animation = &"down"
