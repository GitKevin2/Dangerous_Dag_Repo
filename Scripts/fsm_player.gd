extends StateMachine
class_name PlayerFSM

onready var spr_player: AnimatedSprite;

func _ready():
	if not parent is Player:
		printerr("Parent is not player. the FSM will not work as expected");
	spr_player = parent.get_node("spr_player");
	add_state("Idle")
	add_state("Run")
	add_state("Jump")
	add_state("Fall")
	add_state("Shoot")
	add_state("On_Wall")
	add_state("Wall_Jump")
	add_state("Wall_Slide")
	add_state("Dead")
	call_deferred("set_state", states.Idle);

func _state_logic(delta):
	parent.set_gravity();
	if not state_is("Dead"):
		parent.set_shoot();
		if not state_is("Shoot"):
			if not state_is("Wall_Jump"):
				parent.set_movement(delta);
			parent.set_weapon_switch();
			parent.set_jump();
			parent.set_wall_controls();
	else:
		parent.motion.x = 0;
	parent.motion = parent.move_and_slide(parent.motion, Player.UP);

func _get_transition(_delta):
	var queue_state = null;
	match state:
		states.Idle:
			if Input.is_action_just_pressed("ui_attack"):
				parent.motion.x = 0;
				queue_state = states.Shoot;
			elif parent.is_on_floor():
				if parent.motion.x != 0:
					queue_state = states.Run;
			elif parent.motion.y < 0:
				queue_state = states.Jump;
			else:
				queue_state = states.Fall;
		states.Run:
			if Input.is_action_just_pressed("ui_attack"):
				parent.motion.x = 0;
				queue_state = states.Shoot;
			elif parent.is_on_floor():
				if parent.motion.x == 0:
					queue_state = states.Idle;
			elif parent.motion.y < 0:
				queue_state = states.Jump;
			else:
				queue_state = states.Fall;
		states.Jump:
			if Input.is_action_just_pressed("ui_attack"):
				queue_state = states.Shoot;
			elif parent.is_on_wall() and not parent.is_on_floor():
				if parent.motion.y <= 0:
					queue_state = states.On_Wall;
				elif parent.motion.y > 5:
					queue_state = states.Wall_Slide;
			elif parent.motion.y >= 0:
				queue_state = states.Fall;
		states.Fall:
			if Input.is_action_just_pressed("ui_attack"):
				queue_state = states.Shoot;
			elif parent.is_on_floor():
				if parent.motion.x == 0:
					queue_state = states.Idle;
				else:
					queue_state = states.Run;
			elif parent.is_on_wall():
				if parent.motion.y < 0:
					queue_state = states.Wall_Jump;
				elif parent.motion.y > 5:
					queue_state = states.Wall_Slide;
			elif parent.motion.y < 0:
				queue_state = states.Jump;
		states.On_Wall:
			if parent.is_on_floor():
				queue_state = states.Idle;
			elif Input.is_action_just_pressed("ui_up"):
				queue_state = states.Wall_Jump;
			elif parent.is_on_wall() and parent.motion.y > 5:
				queue_state = states.Wall_Slide;
			elif parent.motion.y > 0:
				queue_state = states.Fall;
			pass
		states.Wall_Jump:
			if Input.is_action_just_pressed("ui_attack"):
				queue_state = states.Shoot;
			elif parent.is_on_wall() and not parent.is_on_floor():
				if parent.motion.y > 5:
					queue_state = states.Wall_Slide;
				else:
					queue_state = states.On_Wall;
			elif parent.motion.y >= 0:
				queue_state = states.Fall;
		states.Wall_Slide:
			if Input.is_action_just_pressed("ui_attack"):
				queue_state = states.Shoot;
			elif parent.is_on_floor():
				queue_state = states.Idle;
			elif parent.motion.y < 0:
				queue_state = states.Wall_Jump
			elif not parent.is_on_wall():
				queue_state = states.Fall;
		states.Dead:
			if not MainHUD.lives.empty():
				queue_state = states.Idle;
			pass
	return queue_state;

func _enter_state(new_state, _old_state):
	var anim: String;
	match new_state:
		states.Idle:
			anim = "Idle"
		states.Run:
			anim = "Run"
		states.Jump:
			anim = "Jump"
		states.Fall:
			anim = "Fall"
		states.Wall_Jump:
			anim = "Jump"
		states.Wall_Slide:
			anim = "Wall-Slide"
		states.Shoot:
			anim = "Shoot"
			set_shoot_anim();
		states.Dead:
			anim = "Dead"
	if [states.On_Wall, states.Wall_Jump].has(state):
		$label_state.set_text("Wall_Jump" if state_is("Wall_Jump") else "On_Wall");
	else:
		$label_state.set_text(anim);
	spr_player.play(anim);

func die():
	parent.stop();
	call_deferred("set_state", states.Dead);
	pass

func dead() -> bool:
	return state_is("Dead");

func set_shoot_anim():
	if not state_is("Shoot"): return;
	yield(spr_player, "animation_finished");
	call_deferred("set_state", previous_state);
	pass

