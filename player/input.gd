extends Node
class_name InputGatherer

@onready var player: CharacterBody3D = $".."


#Only responsible for gathering input, putting it in a neat InputPackage and returning that 
func gather_input() -> InputPackage:
	var new_input = InputPackage.new()
	
	if Input.is_action_just_pressed("ui_accept"):
		new_input.actions.append("jump")
		
	new_input.input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	return new_input
