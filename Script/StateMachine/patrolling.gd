extends State
class_name Patrol
 
@onready var prison_guard = $"../.."
@onready var navigation_agent = $"../../NavigationAgent3D"
@onready var prisoner = prison_guard.prisoner
@onready var ray_cast_3d: RayCast3D = $Prisoner/RayCast3D
 
var current_marker: Marker3D = null
var markerIndex = null
 
@onready var patrol_markers: Array[Marker3D] = prison_guard.patrol_markers


func physics_update(_delta: float) -> void:
	raycast_player()
	var nextMarker = select_next_marker()
	move_toward_marker(nextMarker, _delta)
	
func select_next_marker():
	if markerIndex == null:
		markerIndex = 0
		current_marker = patrol_markers[markerIndex]
		
	if navigation_agent.is_target_reached() or not navigation_agent.is_target_reachable():
		markerIndex += 1
		if markerIndex >= len(patrol_markers):
			markerIndex = 0
	return patrol_markers[markerIndex]

 
func move_toward_marker(marker, delta):
	var direction := Vector3()
	navigation_agent.target_position = marker.global_position
	direction = navigation_agent.get_next_path_position() - prison_guard.global_position
	prison_guard.look_at(marker.global_position + direction)
	prison_guard.rotate_y(deg_to_rad(180))
	direction = direction.normalized()
	var speed = prison_guard.walking_speed
	prison_guard.velocity = prison_guard.velocity.lerp(direction * speed, 1.0 * delta)
	prison_guard.move_and_slide()

func raycast_player():
	##print("Raycasting...")
	const ray_Range = 1000
	
	var space_state = prison_guard.get_world_3d().direct_space_state
	
	var origin = prison_guard.global_position
	var end = prisoner.global_position
	
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true
	
	var result = space_state.intersect_ray(query)
	##print(result)
	
	if result:
		var collider: Node = result["collider"]
		if collider.is_in_group("Players"):
			print("Hello")
			state_machine.transition_to("Chase")


func enter(_msg :={}) -> void:
	if state_machine.animation_player:
		state_machine.animation_player.play("Walk")
	
func exit() -> void:
	if state_machine.animation_player:
		state_machine.animation_player.stop()
