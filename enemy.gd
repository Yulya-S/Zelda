extends CharacterBody2D
@onready var player_scene = $"../../../../Player"
@onready var room = $".."

const SPEED = 100.0
var HP = 20

const colors = ["black", "red"]
var color_idx = 0

var hit = true
var player_enter = false

func _ready() -> void:
	color_idx = randi_range(0, colors.size()-1)
	$enemy_attack.collision_layer = 0
	$enemy_attack.collision_mask = 0
	$AnimatedSprite2D.animation = &"UpDown_" + str(colors[color_idx])
	$enemy_attack/AnimatedSprite2D.hide()
	$AnimatedSprite2D.play()


func _physics_process(delta: float) -> void:
	if hit and HP > 0 and player_enter:
		var direction = (player_scene.position - (position + room.position)).normalized()
		velocity = direction * SPEED
		move_and_slide()


func set_pos(coord: Vector2i):
	position = coord


func _on_hitpoint_area_entered(area: Area2D) -> void:
	if area.name in ["MeleeAttackArea", "Fire"]:
		if HP > 0 and hit:
			hit = false
			if HP - 10 <= 0:
				collision_layer = 0
				collision_mask = 0
				$AnimatedSprite2D.animation = &"Dead_" + str(colors[color_idx])
				HP -= 10
			else:
				HP -= 10
				$AnimatedSprite2D.animation = &"Damage_" + str(colors[color_idx])
				await $AnimatedSprite2D.animation_looped
				$AnimatedSprite2D.animation = &"UpDown_" + str(colors[color_idx])
			hit = true


func _on_attack_zone_area_entered(area: Area2D) -> void:
	if area.name == "hitbox" and hit and HP > 0:
		hit = false
		$AnimatedSprite2D.animation = &"Attack_" + str(colors[color_idx])
		$enemy_attack/AnimatedSprite2D.play()
		$enemy_attack/Timer.start()
		await $enemy_attack/Timer.timeout
		$enemy_attack.collision_layer = 4
		$enemy_attack.collision_mask = 4
		$enemy_attack/AnimatedSprite2D.show()
		await $enemy_attack/AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.animation = &"UpDown_" + str(colors[color_idx])
		$enemy_attack/AnimatedSprite2D.stop()
		$enemy_attack/AnimatedSprite2D.hide()
		$enemy_attack.collision_layer = 0
		$enemy_attack.collision_mask = 0
		hit = true


func _on_visibility_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_enter = true


func _on_visibility_zone_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_enter = false
