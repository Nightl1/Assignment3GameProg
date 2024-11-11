extends State
class_name Attack

func enter(_msg :={}) -> void:
	if state_machine.animation_player:
		state_machine.animation_player.play("Attack")
	
func exit() -> void:
	if state_machine.animation_player:
		state_machine.animation_player.stop()
