extends CharacterBody2D

@onready var meel_attack = $Node2D

var coins = 0
var potions = 0
var arrows = 0

var damage = false

var SPEED = 250.0


func _ready():
	Signals.connect("teleport", Callable(self, "_on_interact"))
	$AnimatedSprite2D.play()

func _physics_process(delta: float) -> void:
	if not damage:
		if Input.is_action_pressed(&"run"):
			SPEED = 400.0
		if Input.is_action_just_released(&"run"):
			SPEED = 250.0
		
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
		if Input.is_action_just_pressed(&"hill") and potions > 0:
			if $"../CanvasLayer/TextureProgressBar".value != $"../CanvasLayer/TextureProgressBar".max_value:
				$"../CanvasLayer/TextureProgressBar".value += 3
				potions -= 1

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


func _on_interact(coord: Vector2i, address: Vector2i):
	position = coord


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "enemy_attack" and not damage:
		damage = true
		$AnimatedSprite2D.animation = &"damage"
		$AnimatedSprite2D.play()
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.animation = &"stop_down"
		$AnimatedSprite2D.play()
		Signals.emit_signal("attack")
		damage = false
	elif area.name == "Prize" and not damage:
		area.hide_prize()
		if area.type == 0:
			arrows += 1
		elif area.type == 1:
			coins += 1
		elif area.type == 2:
			potions += 1
		
		
