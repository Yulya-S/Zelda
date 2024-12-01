extends Node

signal interact() #

signal teleport(coord: Vector2i, address: Vector2i)
signal add_room_to_map(address: Vector2i, room: Node2D)

signal new_message(text: String)
 # POITION - 0, GOLD - 1, ARROW - 2, VASE - 3, CHEST - 4, ADD_ENEMY - 5, ENEMY_DEATH - 6
signal statistic(idx: int, count: int)
