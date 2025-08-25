extends Node
class_name InputGatherer

@onready var player: CharacterBody3D = $".."


#Only responsible for gathering input, putting it in a neat InputPackage and returning that 
func gather_input() -> InputPackage:
	var new_input = InputPackage.new()
	
	new_input.input_direction = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_just_pressed("ui_accept"):
		new_input.actions.append("jump")
	if new_input.input_direction != Vector2.ZERO:
		new_input.actions.append("skate")
	if new_input.actions.is_empty():
		new_input.actions.append("idle")
	
	return new_input
