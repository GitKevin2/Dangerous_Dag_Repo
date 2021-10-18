extends Area2D
class_name Portal, "res://_Misc/Icons/icon_next.png"

# Declare member variables here. Examples:
export(String, FILE, "*.tscn") var next_scene;

onready var box_key_prompt = $canvas_portal/box_key_prompt;
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false);
	var _resp_enter = connect("body_entered", self, "_on_body_entered");
	var _resp_exit = connect("body_exited", self, "_on_body_exited");
	box_key_prompt.hide();

func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
		MainHUD.lives.refill_lives();
		MainHUD.update_base_points();
		var _resp_scene = get_tree().change_scene(next_scene);

func _on_body_entered(body):
	if body is Player:
		set_process(true);
		box_key_prompt.show();

func _on_body_exited(body):
	if body is Player:
		set_process(false);
		box_key_prompt.hide();


