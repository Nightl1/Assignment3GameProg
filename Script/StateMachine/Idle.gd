extends State
class_name Idle

func enter(_msg :={}) -> void:
	if state_machine.animation_player:
		state_machine.animation_player.play("Idle")
	
func exit() -> void:
	if state_machine.animation_player:
		state_machine.animation_player.stop()
