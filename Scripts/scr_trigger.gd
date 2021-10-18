extends Area2D
class_name Trigger

export(Array, String, FILE, "*.gd") var Actor_Objects = PoolStringArray();

onready var active_state: bool = false setget set_active, is_active;
onready var entered: bool = false setget set_entered, has_entered;
onready var actors: Array;

signal triggered(active)


# Called when the node enters the scene tree for the first time.
func _ready():
	for object in Actor_Objects:
		actors.append(load(object));
	var _resp_enter_body = connect("body_entered", self, "_on_entered");
	var _resp_exit_body = connect("body_exited", self, "_on_exited");
	var _resp_enter_area = connect("area_entered", self, "_on_entered");
	var _resp_exit_area = connect("area_exited", self, "_on_exited");
	var _resp_trigger = connect("triggered", self, "_interaction");
	set_process(false);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if _trigger():
		active_state = !active_state;
		emit_signal("triggered", active_state);
	set_process(entered);

func set_entered(is_entered: bool):
	entered = is_entered;

func has_entered():
	return entered;

func set_active(value: bool):
	active_state = value;

func is_active() -> bool:
	return active_state;

func entered_changed() -> bool:
	return action_changed(entered);

func action_changed(comparison: bool) -> bool:
	return active_state != comparison;

func _on_entered(node):
	for object in actors:
		if node is object:
			self.entered = true;
			set_process(entered);
			_entry(node);
			break;

func _on_exited(node):
	for object in actors:
		if node is object:
			self.entered = false;
			_exit(node);
			break;

func _trigger() -> bool:
	return false;

func _interaction(_active: bool) -> void:
	pass

func _entry(_node) -> void:
	pass

func _exit(_node) -> void:
	pass


func force_trigger():
	active_state = !active_state;
	emit_signal("triggered", active_state);
	pass
