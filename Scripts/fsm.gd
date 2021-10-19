extends Node2D
class_name StateMachine
#Based on: https://www.youtube.com/watch?v=BNU8xNRk_oU Game Endeavor "How to build a Simple State Machine"

var state = null setget set_state;
var previous_state = null;
var states = {}

onready var parent = get_parent();

func _physics_process(delta):
	if state != null:
		_state_logic(delta);
		var transition = _get_transition(delta);
		if transition != null:
			self.state = transition;

func _state_logic(_delta):
	pass

func _get_transition(_delta):
	return null;

func _enter_state(_new_state, _old_state):
	pass

func _exit_state(_old_state, _new_state):
	pass

func set_state(new_state):
	previous_state = state;
	state = new_state;
	if previous_state != null:
		_exit_state(previous_state, new_state);
	if new_state != null:
		_enter_state(new_state, previous_state);
	pass

func add_state(state_name):
	states[state_name] = len(states);

func state_is(state_name) -> bool:
	return state == states[state_name];

