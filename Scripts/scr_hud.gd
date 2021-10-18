extends CanvasLayer
class_name HUD

onready var control: Control = $HUD;
onready var lives: Lives = $HUD/Lives;
onready var timer: Timer = $HUD/timer;
onready var anim: AnimationPlayer = $HUD/anim_lives;
onready var weapons: Weapons = $HUD/weapons;
onready var current_ammo = weapons.current();
onready var points: int setget set_points;
onready var base_points: int;

func _ready():
	self.points = 0;
	base_points = points;
	var _resp_timer = timer.connect("timeout", self, "_on_invincible_timeout");
	var _resp_lives = lives.connect("life_lost", self, "set_invincible");
	var _resp_death = lives.connect("dead", self, "_death");
	pass

func set_points(value: int):
	points = value;
	$HUD/box_points/points.set_text(str(points));

func update_base_points():
	self.base_points = points;

func reset_points():
	self.points = base_points;

func set_ammo(value):
	current_ammo.set_text(current_ammo.name + ": " + str(value));

func refresh():
	reset_points();
	end_timer();
	weapons.reset();
	weapons.go_to(0);
	lives.refill_lives();
	pass

func set_invincible():
	lives.invincible = true;
	anim.play("Invincible");
	timer.start(2);
	pass

func end_timer():
	timer.stop();
	_on_invincible_timeout();
	pass

func _on_invincible_timeout():
	lives.visible = true;
	lives.invincible = false;
	anim.stop();
	if lives.low():
		anim.play("Critical");

func _death(__) :
	lives.invincible = true;
	anim.play("Idle");
	pass
