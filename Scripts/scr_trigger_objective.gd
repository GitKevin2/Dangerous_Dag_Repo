extends Trigger
class_name ObjectiveTrigger

func _ready():
	$path.set_process(false);

func _trigger(): return not entered;

func _interaction(active):
	if active:
		$path.set_process(true);
		print("Pie Acquired")
	pass



