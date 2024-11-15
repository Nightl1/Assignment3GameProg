extends CharacterBody3D
 

@export var walking_speed = 3.0
@export var chasing_speed = 20.0
@export var attack_speed = 10.0
@export var vision_length = 100

@export var prisoner : Node3D

@onready var state_machine = $StateMachine
@onready var prison_guard = $"."
 
@export var patrol_markers: Array[Marker3D] = []
@onready var timer: Timer = $"../Prisoner/Timer"


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == prison_guard:
		state_machine.transition_to("Attack")


func template_4(body: Node3D) -> void:
	if body == prison_guard:
		state_machine.transition_to("Attack")
		timer.start(2.0)


func _on_timer_timeout() -> void:
	prisoner.queue_free()
	state_machine.transition_to("Patrolling")
	
