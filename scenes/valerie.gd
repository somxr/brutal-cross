extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

var parent_model : PlayerModel

var is_skating : float = false
var is_turning: float = false


func _ready() -> void:
	#animation_tree.set("parameters/state_anim/transition_request", "idle")
	parent_model = $"../../Model"
	
func _physics_process(delta: float) -> void:
	if parent_model.current_state == parent_model.states["idle"]:
		is_skating=false
		#animation_tree.set("parameters/state_anim/transition_request", "idle")
	elif parent_model.current_state == parent_model.states["skate"]:
		is_skating=true
		var skate_state = parent_model.current_state
		#animation_tree.set("parameters/state_anim/transition_request", "skate")
