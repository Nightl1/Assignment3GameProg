extends State
class_name Chase

@onready var prison_guard = $"../.."
@onready var prisoner = prison_guard.prisoner
@onready var navigation_agent: NavigationAgent3D = $"../../NavigationAgent3D"

func physics_update(delta: float) -> void:
	raycast_player()
	move_toward_prisoner(delta)
	
func move_toward_prisoner(delta):
	var direction := Vector3()
	navigation_agent.target_position = prisoner.global_position
	direction = navigation_agent.get_next_path_position() - prison_guard.global_position
	prison_guard.look_at(prisoner.global_position + direction)
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
			pass

func enter(_msg :={}) -> void:
	if state_machine.animation_player:
		state_machine.animation_player.play("Run")
	
func exit() -> void:
	if state_machine.animation_player:
		state_machine.animation_player.stop()
