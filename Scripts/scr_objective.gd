extends PickUp
class_name Objective, "res://Sprites/Pies/SteaknCheeseIdle2.png"

export(String, "ButterChicken", "MincePie", "SteakAndCheese") var Pie_Sprite;


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true);
	$spr_objective.play(Pie_Sprite); # visible only at runtime
	self.num_points = 250;
	pass

# Placeholder: Objective will change more to the HUD than a standard PickUp
func _on_body_entered(body):
	._on_body_entered(body);
	pass
