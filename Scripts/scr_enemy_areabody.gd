extends Area2D
class_name EnemyArea, "res://icon_color_inverted.png"

export(float) var Gravity = 20;

onready var spawn_point: Vector2 = get_global_position();
onready var spr_enemy: AnimatedSprite = $spr_enemy;
onready var motion: Vector2 = Vector2.ZERO
onready var speed: float = 100;

# Called when the node enters the scene tree for the first time.
func _ready():
	var _resp_damage = global.connect("damage_hit", self, "_on_damage_hit");
	var _resp_body = connect("body_entered", self, "_on_body_entered")
	pass


func _on_body_entered(body):
	if body is Player:
		global.emit_signal("damaged");
	if body is TileMap:
		var _tile: TileMap = body as TileMap;
		pass
	pass

func _on_damage_hit(body, dealer):
	if body == self and dealer.targets_enemy():
		dealer.react(self);
		self.disable();
	pass

func move(movement: Vector2, delta) -> Vector2:
	position += 10 * movement * delta;
	return Vector2.ZERO

func hostile():
	pass

func alert():
	pass

func respawn():
	self.global_position = spawn_point;
	for node in get_children():
		if node is AoE:
			node.queue_free();
	self.enable();
	pass

func disable() -> void:
	self.hide();
	$col_enemy.set_deferred("disabled", true);

func enable() -> void:
	self.show();
	$col_enemy.set_deferred("disabled", false);
	pass

func disabled() -> bool:
	return not visible and $col_enemy.is_disabled();
