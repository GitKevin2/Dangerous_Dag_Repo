extends CanvasLayer
class_name Confirmation, "res://_Misc/Icons/icon_tick.png"

export(String, MULTILINE) var Description = "Are you sure?";
export(String) var Confirm_Text = "Confirm";
export(String) var Cancel_Text = "Cancel";

onready var buttons = $bg_black/container/vbox_container/hbox_buttons;
onready var btn_confirm: Button = buttons.get_node("btn_confirm");
onready var btn_cancel: Button = buttons.get_node("btn_cancel");

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in buttons.get_children():
		button.focus_mode = Control.FOCUS_NONE;
	btn_confirm.text = Confirm_Text
	btn_cancel.text = Cancel_Text
	$bg_black/container/vbox_container/desc.text = Description
	var _resp_confirm = btn_confirm.connect("pressed", self, "_confirm");
	var _resp_cancel = btn_cancel.connect("pressed", self,"_cancel");
	var _resp_close_confirm = btn_confirm.connect("pressed", self, "close");
	var _resp_close_cancel = btn_cancel.connect("pressed", self, "close");
	close(); #closes confirmation window

func keep_open(btn: Button):
	if btn.is_connected("pressed", self, "close"):
		btn.disconnect("pressed", self, "close");
		pass
	pass

func open():
	$bg_black.show();
	PauseMenu.set_process(false);

func close():
	$bg_black.hide();
	PauseMenu.set_process(true);

func _confirm():
	pass

func _cancel():
	pass


