extends Node2D

onready var player: Player = $Player;

func _ready():
	var _resp = MainHUD.control.connect("visibility_changed", self, "_on_hud_visible");
	MainHUD.control.hide();
	MainHUD.set_ammo(len(global.ammo_current));
	BGMusic.stop();
	
	if player:
		var camera: Camera2D = player.get_node("cam_player");
		camera.limit_left = $edge_left.global_position.x + 32;
		camera.limit_right = $edge_right.global_position.x - 32;
		camera.limit_bottom = $edge_bottom.global_position.y;
	pass

func _on_hud_visible():
	if MainHUD.control.visible:
		MainHUD.control.hide();
	pass
