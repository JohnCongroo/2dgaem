extends Node2D
@onready var body = $RigidBody2D
signal my_custom_signal()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass#print(global_position)

func _on_rigid_body_2d_body_entered(body: Node) -> void:
		my_custom_signal.emit(body)
		print('signal emitered ')

