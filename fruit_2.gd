extends Node2D
@onready var body = $RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass#print(global_position)

func _on_area_2d_area_entered(area: Area2D) -> void:
	print('collision2')
	if area.get_parent().get_parent().is_in_group('fruit2'):
		var instance = preload('res://fruit_3.tscn').instantiate()
		instance.global_position = body.global_position
		Globals.join += 1
		if Globals.join % 2 == 0:
			get_parent().add_child(instance)
		queue_free()
	
