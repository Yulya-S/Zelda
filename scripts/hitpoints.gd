extends Area2D

@export var point = 6

func _ready():
	$hitpointAnimation.animation = &"full"
	$hitpointAnimation2.animation = &"full"
	$hitpointAnimation3.animation = &"full"
	
func hit():
	var animation = [&"zero", &"half", &"full"]
	var hitpoint = $hitpointAnimation
	var pp = 0 
	if point >= 4:
		hitpoint = $hitpointAnimation3
		pp = 4
	elif point >= 2:
		hitpoint = $hitpointAnimation2
		pp = 2
	
	for i in range(3):
		if point == pp + i:
			hitpoint.animation = animation[i]

func _process(delta):
	hit()
