extends Panel
class_name Dialogue, "res://_Misc/Icons/icon_dialogue.png"

# Declare member variables here.
export(String, FILE, "*.txt") var Dialogue_File;
export var File_On_Ready = true;
var dialogue = []
var page = 0;


# Called when the node enters the scene tree for the first time.
func _ready():
	if File_On_Ready:
		read_file(Dialogue_File);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	show_chatter()
	if Input.is_action_just_pressed("ui_accept"):
		# If line hasn't finished displaying, display entire line.
		if  $text_box.visible_characters < len(dialogue[page]):
			$text_box.visible_characters = len(dialogue[page]);
		else:
			to_next_page();

func read_file(filename: String):
	# Read File
	var file = File.new();
	file.open(filename, File.READ)
	while not file.eof_reached():
		dialogue.append(file.get_line());
	file.close();
	
	# Add first line of dialogue to dialogue box
	$text_box.set_text(dialogue[page]);

func show_chatter():
	if $text_box.visible_characters < len(dialogue[page]):
		$text_box.visible_characters += 1;

func to_next_page():
	page += 1
	if page == dialogue.size():
		page = 0;
	$text_box.visible_characters = 0;
	$text_box.set_text(dialogue[page]);

func to_first_page():
	page = 0
	$text_box.visible_characters = 0;
	$text_box.set_text(dialogue[page]);
	pass
