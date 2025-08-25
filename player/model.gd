extends Node
class_name PlayerModel

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var player: CharacterBody3D = $".."
@onready var visual: Node3D = $"../visual"

var current_state : State

@onready var states = {
	"idle": $Idle,
	"skate": $Skate,
	"jump": $Jump
}

func _ready():
	current_state = states["idle"]
	for state in states:
		states[state].player = player
		states[state].visual = visual

func update(input: InputPackage, delta: float):
	var next_state = current_state.check_transition(input)
	if next_state != "unchanged":
		switch_state(next_state)
	current_state.update(input, delta)
	print(current_state)

func switch_state(next_state: String):
	current_state.exit_state()
	current_state = states[next_state]
	current_state.enter_state()
	

###########################################################
#func velocity_by_input(input: InputPackage, delta: float) -> Vector3:
	#var new_velocity = player.velocity
	#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#new_velocity.x = direction.x * SPEED
		#new_velocity.z = direction.z * SPEED
	#else:
		#new_velocity.x = move_toward(new_velocity.x, 0, SPEED)
		#new_velocity.z = move_toward(new_velocity.z, 0, SPEED)
	#
		## Handle jump.
	#if input.is_jumping and player.is_on_floor():
		#new_velocity.y += JUMP_VELOCITY
#
	#if not player.is_on_floor():
		#new_velocity.y -= gravity * delta
	#
	#return new_velocity
