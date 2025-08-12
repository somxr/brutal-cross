extends CharacterBody3D

@onready var input_gatherer: InputGatherer = $Input
@onready var model: Node = $Model

func _physics_process(delta: float) -> void:
	var input = input_gatherer.gather_input()
	model.update(input, delta)
	#velocity = model.velocity_by_input(input, delta)	
	move_and_slide()


	
