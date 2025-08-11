extends State

var input_dir

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> String:
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_dir == Vector2.ZERO:
		return "idle"
	if Input.is_action_just_pressed('ui_accept') and parent.is_on_floor():
		return "jump"
	return ""
	
func process_frame(delta: float) -> String:
	return ""

func process_physics(delta: float) -> String:
	
	if input_dir:
		var direction := (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		parent.velocity.x = direction.x * SPEED
		parent.velocity.z = direction.z * SPEED
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, SPEED)
		parent.velocity.z = move_toward(parent.velocity.z, 0, SPEED)
	
	parent.move_and_slide()
	
	if not parent.is_on_floor():
		return "idle"
	return ""
	
