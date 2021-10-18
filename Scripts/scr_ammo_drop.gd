extends PickUp
class_name AmmoDrop

const PROJECTILE = preload("res://Scenes/Objects/Projectile.tscn");


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _collected(_body):
	global.ammo.push_back(PROJECTILE.instance());

