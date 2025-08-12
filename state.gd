extends Node
class_name State

#this is a base class for all states
#one function for transitioning states, and one for updating the model
var player

#all-state flags and variables here

func check_transition(input: InputPackage) -> String:
	print_debug("Error, implement the check_transition function in your state")
	return "Error, implement the check_transition function in your state"
	
func update(input: InputPackage, delta: float):
	pass
	
func enter_state():
	pass

func exit_state():
	pass
