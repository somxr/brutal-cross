extends CharacterBody3D

# Player states
enum PlayerState {
	IDLE,
	MOVING,
	MIDAIR
}

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var current_state: PlayerState = PlayerState.IDLE

func _physics_process(delta: float) -> void:
	# Add the gravity when not on floor
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Get input for state transitions and movement
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var jump_pressed := Input.is_action_just_pressed("ui_accept")
	
	# Determine current state
	update_state(direction, jump_pressed)
	print(current_state)
	# Execute state-specific logic
	match current_state:
		PlayerState.IDLE:
			handle_idle_state(direction, jump_pressed)
		PlayerState.MOVING:
			handle_moving_state(direction, jump_pressed)
		PlayerState.MIDAIR:
			handle_midair_state(direction, jump_pressed)
	
	move_and_slide()

func update_state(direction: Vector3, jump_pressed: bool) -> void:
	# State transitions
	if not is_on_floor():
		current_state = PlayerState.MIDAIR
	elif direction.length() > 0:
		current_state = PlayerState.MOVING
	else:
		current_state = PlayerState.IDLE

func handle_idle_state(direction: Vector3, jump_pressed: bool) -> void:
	# Handle jump from idle
	if jump_pressed:
		velocity.y = JUMP_VELOCITY
	
	# Decelerate to stop
	velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.z = move_toward(velocity.z, 0, SPEED)

func handle_moving_state(direction: Vector3, jump_pressed: bool) -> void:
	# Handle jump while moving
	if jump_pressed:
		velocity.y = JUMP_VELOCITY
	
	# Apply movement
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

func handle_midair_state(direction: Vector3, jump_pressed: bool) -> void:
	# Air control - apply movement input
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		# Optional: reduce air control by decelerating slower
		velocity.x = move_toward(velocity.x, 0, SPEED * 0.5)
		velocity.z = move_toward(velocity.z, 0, SPEED * 0.5)
