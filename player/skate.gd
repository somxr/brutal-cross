extends State
class_name Skate

const SPEED = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func check_transition(input: InputPackage) -> String:
	if input.actions.has("jump"):
		return "jump"
	if input.input_direction == Vector2.ZERO:
		return "idle"
	return "unchanged"
	
func update(input: InputPackage, delta: float):
	player.velocity = velocity_by_input(input, delta)
	player.move_and_slide()
	
func enter_state():
	pass

func exit_state():
	pass

func velocity_by_input(input: InputPackage, delta: float) -> Vector3:
	var new_velocity = player.velocity
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := input.input_direction
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	new_velocity.x = direction.x * SPEED
	new_velocity.z = direction.z * SPEED
	
	if not player.is_on_floor():
		new_velocity.y -= gravity * delta
	
	return new_velocity
