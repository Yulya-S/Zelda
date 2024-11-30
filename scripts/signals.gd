extends Node

signal interact()
signal teleport(coord: Vector2i, address: Vector2i)
signal add_room_to_map(address: Vector2i, room: Node2D)

signal menu_interact(exit_button: bool)
signal new_message(text: String)
signal statistic(idx: int, count: int) # POITION - 0, GOLD - 1, ARROW - 2, VASE - 3, CHEST - 4
signal enemy_death()

signal attack()
signal death()
