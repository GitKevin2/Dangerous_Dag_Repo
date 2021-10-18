extends StateMachine
class_name EnemyFSM

onready var ray_detect: RayCast2D = $vision/ray_detect;

onready var player: Player = null setget set_player;

onready var pos_location: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	if not parent is Enemy:
		printerr("Parent is not enemy. the FSM will not work as expected.")
	var _resp_enter = $vision.connect("body_entered", self, "_on_body_entered");
	var _resp_exit = $vision.connect("body_exited", self, "_on_body_exited");
	var _resp_timer = $alert_timer.connect("timeout", self, "_on_alert_timeout");
	
	add_state("Normal");
	add_state("Alert");
	add_state("Hostile");
	add_state("Dead");
	call_deferred("set_state", states.Normal);
	pass 


func _state_logic(_delta):
	if ["Revive", "Dead"].has(parent.spr_enemy.animation):
		yield(parent.spr_enemy, "animation_finished");
	if parent.motion.x != 0:
		parent.spr_enemy.play("Walk");
		parent.spr_enemy.flip_h = parent.motion.x < 0;
	else:
		parent.spr_enemy.play("Idle");
		pass
	if player:
		ray_detect.cast_to = player.global_position - ray_detect.global_position;
		pass
	if state_is("Hostile"):
		parent.shoot_projectile();
	pass

func _get_transition(_delta):
	var queue_state = null;
	match state:
		states.Normal:
			if parent.disabled():
				queue_state = states.Dead;
			elif player_in_range(160.0) and not player.dead():
				queue_state = states.Alert;
		states.Alert:
			if parent.disabled():
				queue_state = states.Dead;
			elif player_in_range(128.0):
				queue_state = states.Hostile;
			if player and player.dead():
				queue_state = states.Normal;
		states.Hostile:
			if parent.disabled():
				queue_state = states.Dead;
			elif not player_in_range(128.0):
				queue_state = states.Alert;
			if player and player.dead():
				queue_state = states.Normal;
		states.Dead:
			if not parent.disabled():
				queue_state = states.Normal;
	return queue_state;

func _enter_state(new_state, _old_state):
	match new_state:
		states.Normal:
			$label_state.set_text("Normal");
			pos_location = Vector2.ZERO;
		states.Alert:
			$label_state.set_text("Alert");
			pos_location = player.global_position - global_position;
		states.Hostile:
			$label_state.set_text("Hostile");
		states.Dead:
			$label_state.set_text("Dead");
	pass

func _exit_state(old_state, _new_state):
	match old_state:
		states.Alert:
			$alert_timer.stop();
			pass
	pass

func set_player(actor: Player):
	player = actor;

func player_spotted() -> bool:
	if player != null:
		return ray_detect.is_colliding() and ray_detect.get_collider() == player;
	return false;

func player_in_range(distance: float) -> bool:
	return player_spotted() and distance_between(player, parent) <= distance;

func distance_between(a: Node2D, b: Node2D) -> float:
	return a.global_position.distance_to(b.global_position);

func get_dir() -> int:
	var dir: int;
	if pos_location.x > 0:
		dir = 1;
	elif pos_location.x < 0:
		dir = -1;
	else:
		dir = 0;
	return dir;

func _on_alert_timeout():
	self.state = states.Normal;
	player = null;
	pass

func _on_body_entered(body):
	if body is Player:
		player = body;
		ray_detect.cast_to = player.global_position - ray_detect.global_position;
		ray_detect.set_enabled(true)
		if state_is("Alert"):
			$alert_timer.stop();
	pass

func _on_body_exited(body):
	if body is Player:
		player = null;
		if state_is("Alert") and $alert_timer.is_stopped():
			$alert_timer.start(10);
	pass

