extends Trigger
class_name Switch

const SWITCH_OFF = preload("res://Sprites/Trigger Objects/Switch_off.png");
const SWITCH_ON = preload("res://Sprites/Trigger Objects/Switch_on.png");

onready var box_key_prompt: Panel = $canvas_switch/box_key_prompt;

func _ready(): box_key_prompt.hide();

func _trigger(): return Input.is_action_just_pressed("ui_select")

func _interaction(active): 
	if active:
		$spr_switch.texture = SWITCH_ON;
	else:
		$spr_switch.texture = SWITCH_OFF;

func _entry(__): box_key_prompt.show();

func _exit(__): box_key_prompt.hide();


