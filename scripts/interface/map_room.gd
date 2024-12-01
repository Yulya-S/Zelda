extends Node2D
var room: Node2D
var update: bool = false


func _process(delta: float) -> void:
	if $"../../".current_pos == room.room_address and not update:
		update = true
		for i in range(1, len(get_children())): get_child(i).hide()
		return
	elif $"../../".current_pos != room.room_address and update:
		update = false
		var things = [false, false, false]
		var objects = [false, false]
		for i in room.get_children():
			if i.name == "salesman":
				$Bubble5.show()
				break;
		for i in room.get_child(4).get_children():
			var path = i.scene_file_path.split("/")[-1]
			match path:
				"chest.tscn": objects[0] = true
				"enemy.tscn": if i.state != 3: objects[1] = true
			if false not in objects: break
		for i in room.get_child(5).get_children():
			things[i.type] = true
			if false not in things: break
		if objects[0]: $ChestIcon.show()
		if objects[1]: $Bone.show()
		if things[0]: $Arrows.show()
		if things[1]: $HealthPotion.show()
		if things[2]: $Coins.show()


func set_room(room: Node2D):
	self.room = room
