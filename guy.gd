extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const TERMINAL_VELOCITY = 100

var mouse_sens = 0.05
var camera_anglev = 0

const gravity = 10


@onready var camera = $Camera3D
@onready var pause_menu = $PauseMenu

#@onready var ray = $RayCast3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input( event ):
	if event is InputEventKey and not get_tree().paused:
		if event.pressed and event.keycode == KEY_ESCAPE:
			pause_menu.pause()

func _input( event ):
	if event is InputEventMouseMotion:
		rotate_y( deg_to_rad( -event.relative.x * mouse_sens ) )
		var changev =- event.relative.y * mouse_sens
		if camera_anglev + changev>-45 and camera_anglev + changev<30:
			camera_anglev += changev
			camera.rotate_x( deg_to_rad( changev ) )


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
