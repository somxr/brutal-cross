class_name State
extends Node

@export
var SPEED: float = 300

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

# Hold a reference to the parent so that it can be controlled by the state
var parent: Player
# Hold a reference to the state machine for easy state transitions
var state_machine: Node

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> String:
	return ""

func process_frame(delta: float) -> String:
	return ""

func process_physics(delta: float) -> String:
	return ""
