class_name State
extends Node

# abstract class

var state_machine = null

# Virtual methods.
func handle_input(_event: InputEvent):
	pass
	
func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
	
func enter(_msg :={}) -> void:
	pass
	
func exit() -> void:
	pass
