extends Trigger
class_name TorchTrigger

onready var lit: bool = false;

signal torch_lit(active)

#only triggers once via trigger
func _trigger(): return not lit and entered;

func _interaction(__):
	lit = true;
	$spr_torch.play("Lit");
	emit_signal("torch_lit", lit);
	pass

func _entry(node):
	if node is Projectile and node.targets_player():
		set_entered(false);

func _exit(node):
	if node is Projectile:
		node.queue_free();
	pass
