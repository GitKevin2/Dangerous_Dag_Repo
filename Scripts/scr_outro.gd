extends Node2D
class_name Outro

onready var player: Player = $Player;

# Called when the node enters the scene tree for the first time.
func _ready():
	PauseMenu.set_process(true);
	$levels_end.connect("body_entered", self, "_on_end_reached");
	if player:
		var camera: Camera2D = player.get_node("cam_player");
		camera.limit_left = $edge_left.global_position.x + 32;
		camera.limit_right = $edge_right.global_position.x - 64;
		camera.limit_bottom = $edge_bottom.global_position.y;
	BGMusic.stop();
	yield($end_screen/anim_end, "animation_started");
	PauseMenu.set_process(false);
	pass # Replace with function body.

func _on_end_reached(body):
	if body == player:
		$end_screen/anim_end.play("Active");
		player.set_physics_process(false);
		pass
	pass
