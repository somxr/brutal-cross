extends Node

var states: Dictionary = {}
var current_state: State

# Initialize the state machine by giving each child state a reference to the
# parent object it belongs to and enter the default starting_state.
func init(parent: Player) -> void:
	register_all_states()
	for child in get_children():
		if child is State:
			child.parent = parent
			child.state_machine = self
	# Initialize to the default state	
	change_state("idle")
	
# Register all child states in the dictionary
func register_all_states() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child

# Get a state by name
func get_state(state_name: String) -> State:
	return states.get(state_name.to_lower())

# Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: String):
	var state = states.get(new_state.to_lower())
	if not state:
		print("Warning: State '%s' not found" % new_state)
		return
	if current_state == state:
		return
	current_state = state
	current_state.enter()
	
# Pass through functions for the Player to call,
# handling state changes as needed.
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
