extends Panel
class_name Revive

# Declare member variables here.
onready var countdown_progress: ProgressBar = $padding/vbox/bar_countdown;
onready var points_cost: int = 80;

signal revived(status);

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	var _resp_timer = $chance_timer.connect("timeout", self, "_on_timeout");
	var _resp_timer_close = $chance_timer.connect("timeout", self, "close");
	close();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_add"):
		emit_signal("revived", true);
		close();
		pass
	
	if not $chance_timer.is_stopped():
		countdown_progress.value = $chance_timer.time_left;
	pass

func open():
	show();
	set_process(true);
	$chance_timer.start(5);
	pass

func close():
	hide();
	set_process(false);
	$chance_timer.stop();
	pass

func _on_timeout():
	emit_signal("revived", false);
	pass
