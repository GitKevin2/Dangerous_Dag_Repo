extends Trigger
class_name PressurePlate

# triggers on entry and exit of the area.
func _trigger(): return entered_changed()

# Runs when triggered. 'active' is the current state of the trigger.
func _interaction(active):
	$spr_plate.visible = !active;

