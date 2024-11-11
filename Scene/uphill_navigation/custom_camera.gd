class_name Custom_camera_3rd extends Node3D

signal set_cam_rotation(cam_rotation: float)

@onready var pitch_pivot = $"../.."
@onready var yaw_pivot = $"../.."
@onready var camera = $"."

@export var height := 1
@export var distance := 3
@export var mouse_sensitivity: float = 1
@export var disabled: bool = false

var yaw_input: float = 0
var pitch_input: float = 0
const MOUSE_SENSITIVITY_REDUCER = 1000
var true_mouse_sensitivity: float

# Called when the node enters the scene tree for the first time.
func _ready():
	if disabled:
		camera.current = false
	yaw_pivot.position.y = height
	camera.position.z = distance
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	true_mouse_sensitivity = mouse_sensitivity / MOUSE_SENSITIVITY_REDUCER
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if disabled:
		return
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	yaw_pivot.rotate_y(yaw_input)
	#yaw_pivot.rotation.y = lerp(yaw_pivot.rotation.y, yaw_pivot.rotation.y + yaw_input, 0.1 * delta)
	yaw_input = 0.0

	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-30),deg_to_rad(30))
	
	set_cam_rotation.emit(yaw_pivot.rotation.y)
	
	
func _unhandled_input(event: InputEvent) -> void:	
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			
			yaw_input = - event.relative.x * true_mouse_sensitivity
			pitch_input = - event.relative.y * true_mouse_sensitivity
