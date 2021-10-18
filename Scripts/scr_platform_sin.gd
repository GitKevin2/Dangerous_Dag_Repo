extends KinematicBody2D
class_name SinPlatform

export(float) var speed = 0.5;
export(float) var distance = 100;
export(Vector2) var direction = Vector2.ZERO;

onready var time_initial: float = 0;
onready var origin: Vector2 = position;
var objects: Array = []

func _ready():
	var _resp_enter = $area.connect("body_entered", self, "_on_body_entered");
	var _resp_exit = $area.connect("body_exited", self, "_on_body_exited");
	pass


func _physics_process(delta):
	time_initial += delta;
	var pos_curve = sin(time_initial * PI * speed);
	var offset = distance * pos_curve * direction;
	position = origin + offset;
	for object in objects:
		pass
	pass

func _on_body_entered(body):
	if not body is TileMap and body != self:
		objects.append(body);
	pass

func _on_body_exited(body):
	objects.erase(body);
	pass
