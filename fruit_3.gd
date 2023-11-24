extends Node2D
@onready var body = $RigidBody2D
var fruititeration = 3
var joined = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RigidBody2D/RichTextLabel.add_text(str(fruititeration))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass#print(global_position)

func _on_area_2d_area_entered(area: Area2D) -> void:
		if area.get_parent().get_parent().is_in_group('fruit' + str(fruititeration)):
			var instance = preload('res://fruit_3.tscn').instantiate()
			var collision = instance.get_child(0).get_child(1)
			var mesh = instance.get_child(0).get_child(0)
			var joincollision = instance.get_child(0).get_child(3).get_child(0)
			var text = instance.get_child(0).get_child(2)
			fruititeration += 1
			instance.position = body.global_position
			instance.remove_from_group('fruit3')
			#instance.remove_from_group('fruit'+ str(fruititeration))
			instance.fruititeration = fruititeration
			instance.add_to_group("fruit"+ str(instance.fruititeration))
			print(instance.get_groups())
			#instance.get_child(0).get_child(0).col
			#instance.get_child(0).get_child(2).area_entered
			mesh.scale += Vector2(0.5,0.5) * fruititeration
			collision.scale += Vector2(.02,.02) * fruititeration
			joincollision.scale += Vector2(.06,.06) * fruititeration

			Globals.join += 1
			if Globals.join % 2 == 0 && joined == false:
				get_parent().add_child(instance)  
				joined == true

			queue_free()
