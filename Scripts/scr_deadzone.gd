extends Area2D
class_name DeadZone

func _ready():
	var _resp = connect("body_entered", self, "_on_body_entered");
	pass 

func _on_body_entered(body):
	if body is Player:
		MainHUD.lives.end_lives(false);
		body.revive_prompt.hide();
	elif body is Enemy:
		body.disable();
	pass

