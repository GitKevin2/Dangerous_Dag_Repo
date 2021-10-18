extends Confirmation

onready var tree = get_tree();

# Triggers when 'Confirm' button is clicked.
func _confirm():
	var hud_node = MainHUD.control;
	PauseMenu.control.hide();
	global.clear_all_ammo();
	tree.reload_current_scene();
	tree.paused = false;
	MainHUD.refresh();
	hud_node.show();

# Triggers when 'Cancel' button is clicked.
func _cancel():
	pass


