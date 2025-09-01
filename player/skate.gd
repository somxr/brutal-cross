extends State
class_name Skate

## Top speed character moves forward
@export var TOP_SPEED = 3.0 # meters per second
## Top speed character moves while turning
@export var SPEED_DURING_TURN = 2.0
## How fast a character turns from direction it's facing moving to the direction the player is inputing. Circular speed.
#@export var ANGULAR_SPEED = 13.0
#@export var ANGULAR_SPEED_FROM_IDLE = 30.0
@export var ACCELERATION := 3.0 # meters per second^2
@export var DECELERATION := 4.0

## How fast a character turns from direction it's facing moving to the direction the player is inputing. Circular speed. Should be faster when you're slow and decreases as you speed up
@export var angular_speed_curve : Curve

# these are to change the different speeds over time, for example gradually increment from 0 to full speed
var current_speed : float
var current_angular_speed : float
# Different types of velocities get decided if you're turning or moving straight, only gets applied in the end of the movement function
var current_velocity : Vector3

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
	if not player.velocity.is_equal_approx(Vector3.ZERO):
		visual.look_at(player.global_position - player.velocity.normalized())
		
func enter_state():
	pass	
func exit_state():
	pass

func rotate_velocity(input: InputPackage, delta: float):
	var facing_direction := visual.basis.z
	# Gives you the angle IN RADIANS from the visual facing vector to the input vector with a positive or negative sign indicating if its clockwise or anti-clockwise
	# input_dir.slide(UP) just flattens the vector, making sure it's in the x and z with y (up) being zero.  
	var angle : float = facing_direction.signed_angle_to(Vector3(input.input_direction.x,0,input.input_direction.y), Vector3.UP) 
	
	var direction = Vector3(input.input_direction.x,0,input.input_direction.y) 
	
	if input.input_direction:
		#Sample current angular speed from a pre-defined curve, Takes speed as input, and outputs appropriate angular speed 			
		current_angular_speed = angular_speed_curve.sample(current_speed)
		
		#if angle is bigger than angular speed
		if abs(angle) >= current_angular_speed * delta:
			# Rotate the velocity vector by angular speed each frame. So the turning is gradual. Sign(angle) just decides if clockwise or anti.
			# Multiplied by "speed during turn" because this is the total move speed which you should be moving during a turn.
			# Remember if there was no turning it would just be velocity = direction.x * TOP_SPEED. If the speed was always the same then SPEED_DURING_TURN here would also just be speed.
			current_speed = move_toward(current_speed,SPEED_DURING_TURN, ACCELERATION*delta)
			current_velocity = facing_direction.rotated(Vector3.UP, sign(angle) * current_angular_speed * delta) * current_speed
		else:
			#else rotate it by the angle. If the turn is even smaller than the angular speed then just turn it directly by that tiny bit?
			current_speed = move_toward(current_speed,TOP_SPEED, ACCELERATION*delta)
			current_velocity = facing_direction.rotated(Vector3.UP, angle) * current_speed
	else:
			# if no input_direction, then decelerate to zero and bring back all the calculation variables to zero to reset them.
			current_speed = move_toward(current_speed, 0.0, DECELERATION*delta)
			current_velocity = current_velocity.move_toward(Vector3.ZERO, DECELERATION*delta)
	
	# Final velocity will be determined based on the branching of the if statements, whatever it is gets assigned as the final player velocity here		
	player.velocity = current_velocity
