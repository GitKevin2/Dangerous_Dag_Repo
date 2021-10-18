extends AudioStreamPlayer

onready var tracks: Dictionary;

# Called when the node enters the scene tree for the first time.
func _ready():
	tracks["World1"] = preload("res://Sounds/Music/Komiku_-_01_-_Fouler_lhorizon_modified_v4.mp3")
	tracks["World2"] = preload("res://Sounds/Music/Raw Tracks/Simple Desert.ogg");

func play_track(track_key: String):
	if stream != tracks[track_key] or not playing:
		stream = tracks[track_key];
		play();
