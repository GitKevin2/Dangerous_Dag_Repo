extends Sprite

func _ready():
	var _resp = get_parent().connect("triggered", self, "_on_triggered");

func _on_triggered(active):
	visible = not active;
