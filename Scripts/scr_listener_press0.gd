extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var _resp = $path/follow/PressurePlate.connect("triggered", self, "_on_trigger");
	$path.set_process(false);
	pass # Replace with function body.


func _on_trigger(active):
	$path.set_process(active);
	pass
