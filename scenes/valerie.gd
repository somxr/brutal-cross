extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

var parent_model : PlayerModel

var is_skating : float = false
var is_turning: float = false

var skate_state : State

var state_machine : AnimationNodeStateMachinePlayback

func _ready() -> void:
	#animation_tree.set("parameters/state_anim/transition_request", "idle")
	parent_model = $"../../Model"
	state_machine = animation_tree["parameters/playback"]

func _physics_process(delta: float) -> void:
	
	if parent_model.current_state == parent_model.states["idle"]:
		pass
		#animation_tree.set("parameters/state_anim/transition_request", "idle")
	elif parent_model.current_state == parent_model.states["skate"]:
		skate_state = parent_model.current_state
		animation_tree.set("parameters/skating/skate_direction_anim_blend/blend_amount", skate_state.current_turn_blend_value)
		#animation_tree.set("parameters/state_anim/transition_request", "skate")
		#print(state_machine.get_current_node())
		
		# hack solution to go back into skating immediately if input direction during transition to glide 
		if state_machine.get_current_node() == "valerie_anim02_IDLE 2":	
			if !skate_state.is_gliding:
				state_machine.start("skating")
