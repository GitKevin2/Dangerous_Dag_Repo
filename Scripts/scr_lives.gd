extends HBoxContainer
class_name Lives, "res://Sprites/HUD/hud_heartFull.png"

onready var num_lives: int = 3 setget set_, get_;
const HEART_FULL = preload("res://Sprites/HUD/hud_heartFull.png");
const HEART_EMPTY = preload("res://Sprites/HUD/hud_heartEmpty.png");
var invincible = false;

signal life_lost
signal dead(prompt_revive)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_(lives_left: int):
	for i in range(0, lives_left):
		get_child(i).texture = HEART_FULL;
	for i in range(lives_left, num_lives):
		get_child(i).texture = HEART_EMPTY;
	num_lives = lives_left;
	pass

func get_():
	return num_lives;

func refill_lives():
	self.num_lives = 3;

func end_lives(revive_prompt):
	self.num_lives = 0;
	emit_signal("dead", revive_prompt);
	pass

func take_life():
	if not invincible:
		set_(num_lives - 1);
		if self.empty():
			emit_signal("dead", true);
		else:
			emit_signal("life_lost");
	pass
func empty() -> bool:
	return num_lives == 0;

func low() -> bool:
	return num_lives == 1;
