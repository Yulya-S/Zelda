extends Node2D
var room: Node2D
var update: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#var things = [0, 0, 0]
	#if $"../../".current_pos == room.room_address:
		#update = true
		#for i in range(1, len(get_children())):
			#get_child(i).hide()
	#elif update:
		#update = false
		#if room.get_child(-1).name == "Chest":
			#if not room.get_child(-1).open:
				#$ChestIcon.show()
		#if room.get_child(-1).name == "Product":
			#$Bubble5.show()
		#for i in room.get_child(4).get_children():
			#if i is CharacterBody2D and i.HP > 0:
				#$Bone.show()
				#break
		#for i in room.get_child(5).get_children():
			#if 0 not in things:
				#break
			#things[i.type] += 1
		#for i in range(len(things)):
			#if things[i] > 0:
				#get_child(2 + i).show()


func set_room(room: Node2D):
	self.room = room
