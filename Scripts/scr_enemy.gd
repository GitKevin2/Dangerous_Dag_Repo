extends KinematicBody2D
class_name Enemy, "res://icon_color_inverted.png"

export(float) var Speed = 150;
export(float) var Projectile_Speed = 100;

const UP = Vector2.UP;
const PROJECTILE = preload("res://Scenes/Objects/Projectile.tscn");

onready var spawn_point: Vector2 = get_global_position();
onready var spr_enemy: AnimatedSprite = $spr_enemy;
onready var ai: StateMachine = $AI;
onready var motion: Vector2 = Vector2.ZERO
onready var muzzle_pos_x = $pos_muzzle.position.x;

# Called when the node enters the scene tree for the first time.
func _ready():
	var _resp_damage = global.connect("damage_hit", self, "_on_damage_hit");
	var _resp_revive = $death_timer.connect("timeout", self, "respawn");
	pass

func _physics_process(_delta):
	motion.y += global.GRAVITY;
	motion.x = Speed * ai.get_dir();
	motion = move_and_slide(motion, UP);
	pass

func _on_damage_hit(body, dealer):
	if body == self and dealer.targets_enemy():
		dealer.react(self);
		self.disable();
	pass

func respawn():
	self.global_position = spawn_point;
	for child in get_children():
		if child is AoE:
			if child.targets_enemy():
				child.queue_free();
			else:
				child.set_radius(0);
	self.enable();
	pass

func disable():
	spr_enemy.play("Dead");
	yield(spr_enemy, "animation_finished");
	self.hide();
	$death_timer.start(3);
	$col_enemy.set_deferred("disabled", true);
	set_physics_process(false);

func enable():
	$anim_enemy_active.play("FadeIn");
	yield($anim_enemy_active, "animation_finished");
	
	spr_enemy.play("Revive");
	yield(spr_enemy, "animation_finished");
	
	self.show();
	$col_enemy.set_deferred("disabled", false);
	set_physics_process(true);
	pass

func disabled() -> bool:
	return not visible and $col_enemy.is_disabled();

func shoot_projectile():
	$pos_muzzle.position.x = -muzzle_pos_x if $spr_enemy.flip_h else muzzle_pos_x
	if $shoot_cooldown.is_stopped():
		var bullet: Projectile = PROJECTILE.instance();
		owner.add_child(bullet);
		bullet.set_(
			$pos_muzzle.global_transform,
			Damage.TARGET_PLAYER,
			$spr_enemy.flip_h
		);
		bullet.set_speed(Projectile_Speed);
		$shoot_cooldown.start(3);
	pass

