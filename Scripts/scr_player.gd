extends KinematicBody2D
class_name Player, "res://icon.png"

export(float) var Speed = 250;
export(float) var Jump_Height = 500;
export(bool) var Can_Wall_Jump = true; 

enum State {DEAD, ALIVE}

const UP: Vector2 = Vector2.UP;
const PROJECTILE = preload("res://Scenes/Objects/Projectile.tscn");
const SUPER_PROJECTILE = preload("res://Scenes/Objects/SuperProjectile.tscn");

onready var spawn_point: Vector2 = get_global_position();
onready var muzzle_pos_x: float = $pos_muzzle.position.x;
onready var motion: Vector2 = Vector2.ZERO;
onready var ai: StateMachine = $AI;
onready var revive_prompt = $RevivePrompt;

# Called when the node enters the scene tree for the first time.
func _ready():
	var _resp_damage = global.connect("damage_hit", self, "_on_damage_hit");
	var _resp_death = global.connect_death_signal(self);
	var _resp_revive = $RevivePrompt.connect("revived", self, "_revive");
	
	pass # Replace with function body.

func _physics_process(_delta):
	pass

func set_gravity():
	motion.y += global.GRAVITY;

func set_movement(delta):
	if Input.is_action_pressed("ui_right"):
		$spr_player.flip_h = false;
		motion.x = Speed;
	elif Input.is_action_pressed("ui_left"):
		$spr_player.flip_h = true;
		motion.x = -Speed;
	else:
		motion.x = lerp(motion.x, 0, delta) if not is_on_floor() else 0;

func set_jump():
	if is_on_floor():
		# Move up when key pressed.
		if Input.is_action_pressed("ui_up"):
			motion.y = -Jump_Height;
	pass

func set_wall_controls():
	if Can_Wall_Jump:
		if is_on_wall() and not is_on_floor():
			if Input.is_action_just_pressed("ui_up"):
				# Wall-Jump motion
				motion.y = -Jump_Height;
				motion.x = -motion.x;
				$spr_player.flip_h = !$spr_player.flip_h;
			else:
				# Wall-Slide motion
				# for natural feel, player falls slightly before sliding
				if motion.y > 5:
					$spr_player.flip_h = !$spr_player.flip_h;
					motion.y = 2 * global.GRAVITY;
	pass

func set_shoot() -> void:
	$pos_muzzle.position.x = -muzzle_pos_x if $spr_player.flip_h else muzzle_pos_x
	if Input.is_action_just_pressed("ui_add"):
		generate_ammo();
	if is_on_floor():
		rotation_degrees = 0;
	
	if Input.is_action_just_pressed("ui_attack"):
		# Needs some work. it won't go down.
		if not is_on_floor() and Input.is_action_pressed("ui_down"):
			rotation_degrees = 270 if $spr_player.flip_h else 90;
			pass
		self.shoot_projectile();

func set_weapon_switch():
	if Input.is_action_just_pressed("ui_focus_next"):
		MainHUD.weapons.next();
	elif Input.is_action_just_pressed("ui_focus_prev"):
		MainHUD.weapons.previous();
	pass

func _on_damage_hit(body, dealer):
	if body == self and dealer.targets_player():
		dealer.react(self);
		for child in get_children():
			if child is AoE:
				child.queue_free();
		global.emit_signal("damaged");
		pass
	pass

func shoot_projectile():
	if global.ammo_current.empty():
		print("Empty ammo");
		return;
	var bullet: Projectile = global.ammo_current.pop_back();
	owner.add_child(bullet);
	bullet.set_(
		$pos_muzzle.global_transform, 
		Damage.TARGET_ENEMY, 
		$spr_player.flip_h
	);
	MainHUD.set_ammo(len(global.ammo_current));
	pass

func generate_ammo():
	var is_super: bool = MainHUD.weapons.get_index() == 1;
	var scene: PackedScene = SUPER_PROJECTILE if is_super else PROJECTILE;
	var bullet: Projectile = scene.instance()
	if global.consume_points(bullet.get_points_cost()):
		global.ammo_current.push_back(bullet);
	
	MainHUD.set_ammo(len(global.ammo_current));

func stop():
	motion.x = 0;

func dead() -> bool:
	return ai.dead();

func _death(prompt_revive: bool):
	ai.die();
	if prompt_revive:
		$spr_player.play("Dead");
		$RevivePrompt.open();
	else:
		_revive(false);
	pass

func _revive(has_revived: bool):
	if has_revived and global.consume_points(100):
			MainHUD.lives.set_(2);
			MainHUD.set_invincible();
	else:
		var _resp = global.consume_points(20, true);
		self.global_position = spawn_point;
		MainHUD.lives.refill_lives();
		MainHUD.lives.invincible = false;
		pass
	pass
