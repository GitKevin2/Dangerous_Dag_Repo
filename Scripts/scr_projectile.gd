extends Damage
class_name Projectile, "res://Sprites/Fireball/Fireball2.png"

export(float) var Speed = 800 setget set_speed;

onready var direction = 0;
onready var explosion: AoE = $Explosion;

onready var enemy_anim = "Enemy";
onready var player_anim = "Player";

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if [90.0, -90.0, 270.0, -270.0].has(rotation_degrees):
		move_pos_y(delta);
	else:
		move_pos_x(delta);
	
	if $col_projectile.disabled:
		queue_free();
	pass

func explode() -> AoE:
	explosion.start_at(128);
	explosion.target = get_target();
	var impact = $Explosion
	hide();
	$col_projectile.set_deferred("disabled", true);
	remove_child($Explosion);
	return impact

func move_pos_y(delta):
	position.y += Speed * delta;
	pass

func move_pos_x(delta):
	position.x += Speed * delta * direction;
	
	pass

func set_target(value):
	.set_target(value)
	if targets_enemy():
		$spr_projectile.play(player_anim);
	elif targets_player():
		$spr_projectile.play(enemy_anim);
	pass

func set_flip_h(set_flipped: bool):
	$spr_projectile.flip_h = set_flipped;
	if set_flipped:
		direction = -1;
	else:
		direction = 1;

func react(body):
	var impact: AoE = self.explode();
	body.call_deferred("add_child", impact);
	pass

func set_(arg_transform: Transform2D, arg_target: int = 0, flip_h: bool = false):
	set_global_transform(arg_transform);
	set_target(arg_target);
	set_flip_h(flip_h);

func set_speed(value: float):
	Speed = value;

func get_points_cost() -> int:
	return 50;
