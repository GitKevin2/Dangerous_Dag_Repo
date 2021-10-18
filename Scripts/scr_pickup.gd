extends Area2D
class_name PickUp

onready var num_points: int = 0;


# Called when the node enters the scene tree for the first time.
func _ready():
	 var _resp = connect("body_entered", self, "_on_body_entered");

func _on_body_entered(body):
	if body is Player:
		_collected(body);
		queue_free();
	pass

func _collected(_body):
	MainHUD.points += num_points;
	pass

