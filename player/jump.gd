extends State
class_name Jump

@export var jump_velocity = 4.5
@export var midair_control_speed = 5.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func check_transition(input: InputPackage) -> String:
	if player.is_on_floor():
		input.actions.sort_custom(states_priority_sort)
		return input.actions[0]
	return "unchanged"
	
func update(input: InputPackage, delta: float):
	player.velocity = velocity_by_input(input, delta)
	
func enter_state():
	player.velocity.y += jump_velocity

func exit_state():
	pass

func velocity_by_input(input: InputPackage, delta: float) -> Vector3:
	var new_velocity = player.velocity
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := input.input_direction
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	new_velocity.x = direction.x * midair_control_speed
	new_velocity.z = direction.z * midair_control_speed
	
	if not player.is_on_floor():
		new_velocity.y -= gravity * delta
	
	return new_velocity
