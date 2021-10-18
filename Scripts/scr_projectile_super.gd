extends Projectile
class_name SuperProjectile, "res://Sprites/Fireball/Fireball0.png"

onready var enemy_count: int = 0;

func _ready():
	player_anim = "Player Super"
	pass

func react(body):
	enemy_count += 1;
	if enemy_count > 2:
		.react(body);
	pass

func get_points_cost() -> int:
	return 80;
