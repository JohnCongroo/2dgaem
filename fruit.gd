extends Node2D
@onready var body = $RigidBody2D
var fruititeration
var bodies
signal join(body)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#body.apply_central_impulse(Vector2(0,-10))
  # Replace 500 with your desired impulse strength

func apply_outward_impulse(strength):
	if bodies:
		for body in bodies:
			if body is RigidBody2D:
				var direction = (body.global_position - global_position).normalized()
				body.apply_impulse(global_position, direction * strength)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	bodies = body.get_colliding_bodies()

func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if body.get_parent().is_in_group('fruit' + str(fruititeration)):
		$AnimationPlayer.play('vanish')
		$RigidBody2D/RichTextLabel.clear()
		#visible = false
		$RigidBody2D/CollisionShape2D.set_deferred('disabled', true)
		#body.get_parent().visible = false
		#body.get_child(0).set_deferred('disabled', true)
		join.emit(body)

#func _on_area_2d_area_entered(area: Area2D) -> void:
#	if area.get_owner().is_in_group('fruit' + str(fruititeration)):
#
#		join.emit(area)
#		queue_free()# Replace with function body.

