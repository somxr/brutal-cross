extends State

func enter() -> void:
	super()
	parent.velocity.x = 0

func process_input(event: InputEvent) -> String:
	if Input.is_action_just_pressed('ui_accept') and parent.is_on_floor():
		return "jump"
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
		return "move"
	return ""

func process_physics(delta: float) -> String:
	parent.velocity.y -= gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return "idle"
	return ""
	
	
