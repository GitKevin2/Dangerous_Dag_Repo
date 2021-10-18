extends Node2D
class_name SwitchListener1

onready var parent: Trigger = get_parent();
onready var processing: bool = false;
onready var paths: Array = [];
onready var speed: float;

# Called when the node enters the scene tree for the first time.
func _ready():
	var _resp = parent.connect("triggered", self, "_on_trigger");
	for child in get_children():
		if child is Path2D:
			child.set_process(false);
			paths.append(child);
	speed = paths[0].Speed;
	pass # Replace with function body.


func _on_trigger(active: bool):
	if not processing:
		for path in paths:
			path.set_process(true);
		processing = true;
	for path in paths:
		if active:
			path.Speed = speed;
		else:
			path.Speed = -speed;
	pass
