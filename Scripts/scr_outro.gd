extends Node2D

onready var player: Player = $Player;
onready var box_key_prompt = $levels_end/canvas/box_key_prompt;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	PauseMenu.set_process(true);
	$levels_end.connect("body_entered", self, "_on_end_reached", [true]);
	$levels_end.connect("body_exited", self, "_on_end_reached", [false]);
	if player:
		var camera: Camera2D = player.get_node("cam_player");
		camera.limit_left = $edge_left.global_position.x + 32;
		camera.limit_right = $edge_right.global_position.x - 32;
		camera.limit_bottom = $edge_bottom.global_position.y;
	BGMusic.stop();
	yield($end_screen/anim_end, "animation_started");
	PauseMenu.set_process(false);
	pass # Replace with function body.

func _process(__):
	if Input.is_action_just_pressed("ui_select"):
		$end_screen/anim_end.play("Active");
		player.set_physics_process(false);
		pass
	pass

func _on_end_reached(body, entered: bool):
	if body == player:
		box_key_prompt.set_visible(entered);
		set_process(entered);
	pass
