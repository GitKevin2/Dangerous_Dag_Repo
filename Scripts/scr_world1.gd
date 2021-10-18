extends Node2D
class_name World1

onready var player: Player = $Player;

# Called when the node enters the scene tree for the first time.
func _ready():
	MainHUD.control.show();
	MainHUD.set_ammo(len(global.ammo_current));
	BGMusic.play_track("World1");
	if player:
		var camera: Camera2D = player.get_node("cam_player");
		camera.limit_left = $edge_left.global_position.x + 32;
		camera.limit_right = $edge_right.global_position.x - 32;
		camera.limit_bottom = $deadzone0.global_position.y - 96;
	pass
