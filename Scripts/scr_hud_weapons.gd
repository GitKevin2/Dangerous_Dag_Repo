extends VBoxContainer
class_name Weapons

onready var current_index: int = 0 setget , get_index;

signal weapons_switched;

# Called when the node enters the scene tree for the first time.
func _ready():
	self.go_to(0);
	pass # Replace with function body.


func get_index(): return current_index;


func current(): return get_child(current_index);


func go_to(i: int):
	get_child(current_index).hide();
	get_child(i).show();
	current_index = i;
	emit_signal("weapons_switched");
	pass


func next():
	var i: int = current_index + 1;
	if i == get_child_count():
		i = 0;
	go_to(i);


func previous():
	var i: int = current_index - 1;
	if i < 0:
		i = get_child_count() - 1;
	go_to(i);


func reset():
	for weapon in get_children():
		weapon.set_text(weapon.name + ": " + str(0));
		pass
	pass
