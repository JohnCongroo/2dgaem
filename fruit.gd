extends Node2D
@onready var body = $RigidBody2D
var fruititeration = 1
signal join(body)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RigidBody2D/RichTextLabel.add_text("fuck")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass#print(global_position)

func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if body is RigidBody2D and body.get_parent().is_in_group('fruit' + str(fruititeration)):
		join.emit(body)
		queue_free()
		print('yaboinga dagoinba ')

