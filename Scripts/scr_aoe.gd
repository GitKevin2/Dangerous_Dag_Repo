extends Damage
class_name AoE

onready var dissipate_threshold: float = -1;
onready var expansion_rate: float = 0;

func _ready():
	set_radius(0);
	set_physics_process(false);
	pass 

func _physics_process(_delta):
	
	pass

func start_at(value):
	set_radius(value);
	$timer_active.start(1);
	yield($timer_active, "timeout");
	set_radius(0);

func set_radius(value):
	$radius.shape.radius = value;

func get_radius():
	return $radius.shape.radius;

func add_to_radius(value):
	set_radius(get_radius() + value);

func _on_fade():
	set_radius(0);

func _on_entered(body):
	global.emit_signal("damage_hit", body, self);


