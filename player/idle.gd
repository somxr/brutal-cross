extends State
class_name Idle

func check_transition(input: InputPackage) -> String:
	if input.actions.has("jump"):
		return "jump"
	if input.input_direction != Vector2.ZERO:
		return "skate"
	return "unchanged"
	
func update(input: InputPackage, delta: float):
	pass
	
func enter_state():
	player.velocity.x = 0
	player.velocity.z = 0

func exit_state():
	pass
