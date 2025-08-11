extends State

var input_dir

@export
var jump_force: float = 900.0

func enter() -> void:
	super()
	parent.velocity.y = -jump_force

func process_input(event: InputEvent) -> String:
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	return ""

func process_physics(delta: float) -> String:
	parent.velocity.y -= gravity * delta
	var direction := (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if parent.velocity.y > 0:
		#return "fall"	
	if input_dir:
		parent.velocity.x = direction.x * SPEED
		parent.velocity.z = direction.z * SPEED
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, SPEED)
		parent.velocity.z = move_toward(parent.velocity.z, 0, SPEED)
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if parent.direction != Vector3.ZERO:
			return "move"
		return "idle"
	
	return ""
