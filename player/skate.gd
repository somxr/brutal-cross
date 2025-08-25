extends State
class_name Skate

#@export var SPEED = 3.0
#@export var TURN_SPEED = 2
#@export var ANGULAR_SPEED = 13

@export var top_speed := 5.0
@export var acceleration := 3.0
@export var decelaration := 1.5
var _xz_velocity : Vector3

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func check_transition(input: InputPackage) -> String:
	input.actions.sort_custom(states_priority_sort)
	if input.actions[0] == "skate" or player.velocity != Vector3.ZERO:
		return "unchanged"
	return input.actions[0]
	
func update(input: InputPackage, delta: float):
	#rotate_velocity(input, delta)
	#player.velocity = velocity_by_input(input, delta)
	skate_velocity(input, delta)
	visual.look_at(player.global_position - player.velocity.normalized())
	player.move_and_slide()
	
func enter_state():
	pass

func exit_state():
	pass

func skate_velocity(input: InputPackage, delta: float):
	_xz_velocity = Vector3(player.velocity.x,0,player.velocity.z)
	var direction = Vector3(input.input_direction.x,0,input.input_direction.y) 
	if direction:
		_xz_velocity = _xz_velocity.move_toward(direction * top_speed, acceleration*delta)
	else:
		_xz_velocity = _xz_velocity.move_toward(Vector3.ZERO, decelaration*delta)
		
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta
		
	player.velocity.x = _xz_velocity.x
	player.velocity.z = _xz_velocity.z

#func rotate_velocity(input: InputPackage, delta: float):
	#var input_dir := Vector3(input.input_direction.x,0,input.input_direction.y)
	#var facing_direction = visual.basis.z
	#var angle = facing_direction.signed_angle_to(input_dir.slide(Vector3.UP), Vector3.UP) 
	#if abs(angle) >= ANGULAR_SPEED * delta:
		#player.velocity = facing_direction.rotated(Vector3.UP, sign(angle) * ANGULAR_SPEED * delta) * TURN_SPEED
	#else:
		#player.velocity = facing_direction.rotated(Vector3.UP, angle) * SPEED
#
#
#func velocity_by_input(input: InputPackage, delta: float) -> Vector3:
	#var new_velocity = player.velocity
	#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := input.input_direction
	#var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#
	#new_velocity.x = direction.x * SPEED
	#new_velocity.z = direction.z * SPEED
	#
	#if not player.is_on_floor():
		#new_velocity.y -= gravity * delta
	#
	#return new_velocity
