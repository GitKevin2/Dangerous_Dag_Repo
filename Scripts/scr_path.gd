extends Path2D


export(float) var Speed = 100;

func _process(delta):
	$follow.offset += Speed * delta;
	pass
