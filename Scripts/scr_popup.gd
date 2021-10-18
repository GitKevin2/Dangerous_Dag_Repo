extends Area2D
class_name MyPopUp, "res://_Misc/Icons/icon_popup.png"

# Declare member variables here. 
export (String, FILE, "*.txt") var Dialogue_File;


# Called when the node enters the scene tree for the first time.
func _ready():
	$DialogueBox.read_file(Dialogue_File);
	$DialogueBox.set_process(false);
	var _resp_enter = connect("body_entered", self, "_on_body_entered");
	var _resp_exit  = connect("body_exited", self, "_on_body_exited");

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_body_entered(body):
	if body is Player:
		$canvas_popup/box_key_prompt.show();
		$DialogueBox.set_process(true);
		$DialogueBox.show()

func _on_body_exited(body):
	if body is Player:
		$canvas_popup/box_key_prompt.hide();
		$DialogueBox.set_process(false);
		$DialogueBox.hide()
		$DialogueBox.to_first_page();


