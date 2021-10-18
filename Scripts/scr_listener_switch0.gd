extends Node2D
class_name SwitchListener0

onready var parent: Trigger = get_parent();
onready var speed = $path.Speed;


# Called when the node enters the scene tree for the first time.
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


