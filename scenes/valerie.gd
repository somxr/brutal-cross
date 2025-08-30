extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

var parent_model : PlayerModel

func _ready() -> void:
	animation_tree.set("parameters/state_anim/transition_request", "idle")
	parent_model = $"../../Model"
	
func _physics_process(delta: float) -> void:
	
	if parent_model.current_state == parent_model.states["idle"]:
		animation_tree.set("parameters/state_anim/transition_request", "idle")
	elif parent_model.current_state == parent_model.states["skate"]:
		animation_tree.set("parameters/state_anim/transition_request", "skate")
