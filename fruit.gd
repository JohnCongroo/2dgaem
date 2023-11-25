extends Node2D
@onready var body = $RigidBody2D
var fruititeration
signal join(body)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass#print(global_position)

func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if body.get_parent().is_in_group('fruit' + str(fruititeration)):
		visible = false
		$RigidBody2D/CollisionShape2D.set_deferred('disabled', true)
		#body.get_parent().visible = false
		#body.get_child(0).set_deferred('disabled', true)
		join.emit(body)

#func _on_area_2d_area_entered(area: Area2D) -> void:
#	if area.get_owner().is_in_group('fruit' + str(fruititeration)):
#
#		join.emit(area)
#		queue_free()# Replace with function body.

