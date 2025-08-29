extends State
class_name Skate

## Top speed character moves forward
@export var TOP_SPEED = 3.0 # meters per second
## Top speed character moves while turning
@export var TURN_SPEED = 2.0
## How fast a character turns from direction it's facing moving to the direction the player is inputing. Circular speed.
@export var ANGULAR_SPEED = 13.0
@export var ANGULAR_SPEED_FROM_IDLE = 30.0
@export var ACCELERATION := 3.0 # meters per second^2
@export var DECELERATION := 4.0

#@export var top_speed := 5.0 # meters per second
#var _xz_velocity : Vector3 # to separate ground velocity from vertical velocity
#@export var rotation_speed : float = PI * 2 #unit is PI per second so default speed is 2 PI/sec 
#var angle_difference : float 

# these are to change the different speeds over time, for example gradually increment from 0 to full speed
var calculated_speed : float
var calculated_angular_speed : float
# Different types of velocities get decided if you're turning or moving straight, only gets applied in the end of the movement function
var calculated_velocity : Vector3


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
			#_xz_velocity = _xz_velocity.move_toward(direction * top_speed, ACCELERATION*delta)
		#else:
			#_xz_velocity = _xz_velocity.move_toward(direction * top_speed, DECELERATION*delta)
	#else:
		#_xz_velocity = _xz_velocity.move_toward(Vector3.ZERO, DECELERATION*delta)
		#
	#if not player.is_on_floor():
		#player.velocity.y -= gravity * delta
		#
	#player.velocity.x = _xz_velocity.x
	#player.velocity.z = _xz_velocity.z

func rotate_velocity(input: InputPackage, delta: float):
	var facing_direction := visual.basis.z
	# Gives you the angle IN RADIANS from the visual facing vector to the input vector with a positive or negative sign indicating if its clockwise or anti-clockwise
	# input_dir.slide(UP) just flattens the vector, making sure it's in the x and z with y (up) being zero.  
	var angle : float = facing_direction.signed_angle_to(Vector3(input.input_direction.x,0,input.input_direction.y), Vector3.UP) 
	
	var direction = Vector3(input.input_direction.x,0,input.input_direction.y) 
	
	if input.input_direction:
		#if angle is bigger than angular speed
		if abs(angle) >= ANGULAR_SPEED * delta:
			#if player.velocity.length() < 0.2 and abs(rad_to_deg(angle)) > 165:
				#print("entering quick turn")
				##player.velocity = Vector3.ZERO
				##calculated_speed = 0.0
				##visual.look_at(player.global_position - direction)
				##calculated_angular_speed = move_toward(calculated_angular_speed,ANGULAR_SPEED_FROM_IDLE, ACCELERATION*delta)
				##calculated_velocity = facing_direction.rotated(Vector3.UP, sign(angle) * ANGULAR_SPEED_FROM_IDLE * delta) * 0.1
				#visual.look_at(facing_direction.rotated(Vector3.UP, sign(angle) * ANGULAR_SPEED_FROM_IDLE * delta))
				
			#else:
			# rotate the velocity vector by angular speed each frame. So the turning is gradual. Sign(angle) just decides if clockwise or anti.
			# Multiplied by "turn speed" because this is the move speed which you should be moving during a turn.
			# Remember if there was no turning it would just be velocity = direction.x * TOP_SPEED. If the speed was always the same then TURN_SPEED here would also just be speed.
			calculated_speed = move_toward(calculated_speed,TURN_SPEED, ACCELERATION*delta)
			calculated_angular_speed = move_toward(calculated_angular_speed,ANGULAR_SPEED, ACCELERATION*5*delta)
			calculated_velocity = facing_direction.rotated(Vector3.UP, sign(angle) * calculated_angular_speed * delta) * calculated_speed
		else:
			#else rotate it by the angle. If the turn is even smaller than the angular speed then just turn it directly by that tiny bit?
			calculated_speed = move_toward(calculated_speed,TOP_SPEED, ACCELERATION*delta)
			calculated_velocity = facing_direction.rotated(Vector3.UP, angle) * calculated_speed
	else:
			# if no input_direction, then decelerate to zero and bring back all the calculation variables to zero to reset them.
			calculated_speed = move_toward(calculated_speed, 0.0, DECELERATION*delta)
			calculated_angular_speed = move_toward(calculated_angular_speed, 0.0, DECELERATION*delta)
			calculated_velocity = calculated_velocity.move_toward(Vector3.ZERO, DECELERATION*delta)
	#print("left quick turn")
	# Calculated velocity will be determined based on the branching of the if statements, whatever it is gets assigned as the final player velocity here		
	player.velocity = calculated_velocity



#
#func velocity_by_input(input: InputPackage, delta: float) -> Vector3:
	#var new_velocity = player.velocity
	#
	## Get the input direction and handle the movement/DECELERATION.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := input.input_direction
	#var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#
	#new_velocity.x = direction.x * TOP_SPEED
	#new_velocity.z = direction.z * TOP_SPEED
	#
	#if not player.is_on_floor():
		#new_velocity.y -= gravity * delta
	#
	#return new_velocity
