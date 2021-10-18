extends Node2D


onready var parent: Trigger = get_parent();
onready var speed = $path.Speed;

func _ready():
	var _resp = parent.connect("triggered", self, "_on_trigger");
	$path.set_process(false);
	pass # Replace with function body.

func _on_trigger(active: bool):
	$path.set_process(true);
	if active:
		$path.Speed = speed;
	else:
		$path.Speed = -speed;
	pass
