extends CanvasLayer

# Declare member variables here.
onready var control: Control = $menu;
onready var btn_resume: Button = $menu/list_buttons/btn_resume;
onready var btn_restart: Button = $menu/list_buttons/btn_restart;
onready var btn_quit: Button = $menu/list_buttons/btn_quit;
onready var tree: SceneTree = get_tree();
onready var hud: Control = MainHUD.control;

onready var sfx: Dictionary;


# Called when the node enters the scene tree for the first time.
func _ready():
	$menu.hide();
	sfx["open"] = preload("res://Sounds/SFX/menu_open.mp3");
	sfx["close"] = preload("res://Sounds/SFX/menu_close.mp3");
	for button in $menu/list_buttons.get_children():
		button.focus_mode = Control.FOCUS_NONE;
	var _resp_resume = btn_resume.connect("pressed", self, "_on_resume");
	var _resp_restart = btn_restart.connect("pressed", self, "_on_restart");
	var _resp_quit = btn_quit.connect("pressed", self, "_on_quit");
	var _resp_visible = $menu.connect("visibility_changed", self, "_menu_visibility_changed");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_menu"):
		tree.paused = !tree.paused;
		$menu.visible = !$menu.visible;
		hud.visible = !hud.visible;
	pass

func play_sound(sound_key: String):
	$audio_sfx.stream = sfx[sound_key];
	$audio_sfx.play();
	pass

func _on_resume():
	$menu.hide();
	hud.show();
	tree.paused = false;
	pass

func _on_restart():
	btn_restart.get_node("confirmation").open();
	pass

func _on_quit():
	btn_quit.get_node("confirmation").open();
	pass

func _menu_visibility_changed():
	play_sound("open" if $menu.visible else "close");
	pass
