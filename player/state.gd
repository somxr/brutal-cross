extends Node
class_name State
#this is a base class for all states
#one function for transitioning states, and one for updating the model

#all-state flags and variables here
var player : CharacterBody3D
var visual: Node3D

#Data structure holding all states and their priorities
static var states_priority : Dictionary = {
	"idle" : 1,
	"skate" : 2,
	"jump" : 10  # be generous to not edit this to much when sprint, dash, crouch etc are added
}

#custom sort function to sort the actions based on priority, from highest to lowest
static func states_priority_sort(a : String, b : String):
	if states_priority[a] > states_priority[b]:
		return true
	else:
		return false

func check_transition(input: InputPackage) -> String:
	print_debug("Error, implement the check_transition function in your state")
	return "Error, implement the check_transition function in your state"
	
func update(input: InputPackage, delta: float):
	pass
	
func enter_state():
	pass

func exit_state():
	pass
