extends State
class_name Skate

@export var SPEED = 3.0
@export var TURN_SPEED = 2
@export var ANGULAR_SPEED = 13

var facing_direction : Vector3
var angle : float

#
#@export var top_speed := 5.0 # meters per second
#@export var acceleration := 3.0 # meters per second^2
#@export var decelaration := 1.5 
#var _xz_velocity : Vector3 # to separate ground velocity from vertical velocity
#@export var rotation_speed : float = PI * 2 #unit is PI per second so default speed is 2 PI/sec 
#
#var angle_difference : float 

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func check_transition(input: InputPackage) -> String:
	input.actions.sort_custom(states_priority_sort)
	if input.actions[0] == "skate" or player.velocity != Vector3.ZERO:
		return "unchanged"
	return input.actions[0]
	
func update(input: InputPackage, delta: float):
	rotate_velocity(input, delta)
	#player.velocity = velocity_by_input(input, delta)
	#skate_velocity(input, delta)
	visual.look_at(player.global_position - player.velocity.normalized())
	player.move_and_slide()
	
func enter_state():
	pass

func exit_state():
	pass

#func skate_velocity(input: InputPackage, delta: float):
	#_xz_velocity = Vector3(player.velocity.x,0,player.velocity.z)
	#var direction = Vector3(input.input_direction.x,0,input.input_direction.y) 
	#
	#
	#
	#if direction:
		#angle_difference = wrapf(atan2(direction.x, direction.z) - visual.rotation.y, -PI, PI) 
		#visual.rotation.y += clamp(rotation_speed * delta, 0, abs(angle_difference)) * sign(angle_difference)
		#
		#if direction.dot(player.velocity) >= 0:
			#_xz_velocity = _xz_velocity.move_toward(direction * top_speed, acceleration*delta)
		#else:
			#_xz_velocity = _xz_velocity.move_toward(direction * top_speed, decelaration*delta)
	#else:
		#_xz_velocity = _xz_velocity.move_toward(Vector3.ZERO, decelaration*delta)
		#
	#if not player.is_on_floor():
		#player.velocity.y -= gravity * delta
		#
	#player.velocity.x = _xz_velocity.x
	#player.velocity.z = _xz_velocity.z

func rotate_velocity(input: InputPackage, delta: float):
	facing_direction = visual.basis.z
	# Gives you the angle from the visual facing vector to the input vector with a positive or negative sign indicating if its 
	# clockwise or anti-clockwise
	# input_dir.slide(UP) just flattens the vector, making sure it's in the x and z with y (up) being zero.  
	angle = facing_direction.signed_angle_to(Vector3(input.input_direction.x,0,input.input_direction.y), Vector3.UP) 
	#if angle is bigger than angular speed
	if abs(angle) >= ANGULAR_SPEED * delta:
		# rotate the velocity vector by angular speed each frame. So the turning is gradual. Sign(angle) just decides if clockwise or anti.
		# Multiplied by "turn speed" because this is the move speed which you should be moving during a turn.
		# Remember if there was no turning it would just be velocity = direction.x * SPEED. If the speed was always the same then TURN_SPEED here would also just be speed.
		player.velocity = facing_direction.rotated(Vector3.UP, sign(angle) * ANGULAR_SPEED * delta) * TURN_SPEED
	else:
		#else rotate it by the angle. I guess if the turn is even smaller than the angular speed then just turn it directly by that tiny bit?
		player.velocity = facing_direction.rotated(Vector3.UP, angle) * SPEED

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
