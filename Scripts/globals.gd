extends Node
class_name Globals

const GRAVITY: float = 20.0;

onready var pause_menu_control = PauseMenu.get_node("menu");
onready var hud_control = MainHUD.get_node("HUD")
onready var ammo: Array = [];
onready var super_ammo: Array = [];
onready var all_ammo: Array = [ammo, super_ammo];
onready var ammo_current: Array;


#warning-ignore:unused_signal
signal damaged;
#warning-ignore:unused_signal
signal damage_hit(body, dealer);

func _ready() -> void:
	ammo_current = all_ammo[MainHUD.weapons.get_index()];
	var _resp_life = connect("damaged", MainHUD.lives, "take_life");
	var _resp_weapon = MainHUD.weapons.connect("weapons_switched", self, "_on_weapon_switch");
	pass

func _on_weapon_switch():
	MainHUD.current_ammo = MainHUD.weapons.current();
	ammo_current = all_ammo[MainHUD.weapons.get_index()];

func clear_all_ammo():
	ammo.clear();
	super_ammo.clear();

func connect_death_signal(target, signal_method: String = "_death"):
	return MainHUD.lives.connect("dead", target, signal_method);

func consume_points(value: int, default_to_zero: bool = false) -> bool:
	if MainHUD.points - value >= 0:
		MainHUD.points -= value;
	elif default_to_zero:
		MainHUD.points = 0;
	else:
		print("Insufficient number of points");
		return false;
	return true;

