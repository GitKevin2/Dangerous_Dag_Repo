extends Node2D
class_name World2

onready var player: Player = $Player;


# Called when the node enters the scene tree for the first time.
func _ready():
	var _resp = global.connect_death_signal(self, "_on_return_to_start");
	var _resp2 = player.revive_prompt.connect("revived", self, "_on_return_to_start");
	BGMusic.play_track("World2");
	
	if player:
		var camera: Camera2D = player.get_node("cam_player");
		camera.limit_left = $edge_left.global_position.x + 32;
		camera.limit_bottom = $deadzone0.global_position.y - 96;
		camera.limit_right = $edge_right.global_position.x - 32;
		camera.limit_top = $pos_top.global_position.y;
		pass


func _on_return_to_start(revived):
	var switch0: Switch = $Triggers/Switch0
	var plate_path: Path2D = $Triggers/plate_listener/path;
	if not revived:
		if switch0.is_active():
			switch0.force_trigger()
		plate_path.get_node("follow").set_offset(0);
	
	pass


