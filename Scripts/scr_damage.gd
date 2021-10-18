extends Area2D
class_name Damage

enum {TARGET_NONE, TARGET_PLAYER, TARGET_ENEMY}

onready var target = TARGET_NONE setget set_target, get_target;

func _ready():
	var _resp_area = connect("area_entered", self, "_on_entered");
	var _resp_body = connect("body_entered", self, "_on_entered");

func set_target(value):
	target = value;

func get_target():
	return target;

func has_target() -> bool:
	return targets_player() or targets_enemy();

func targets_player() -> bool:
	return target == TARGET_PLAYER;

func targets_enemy() -> bool:
	return target == TARGET_ENEMY;

func react(_body):
	pass

func _on_entered(body):
	if body is TileMap:
		queue_free();
	else:
		global.emit_signal("damage_hit", body, self);
	pass


