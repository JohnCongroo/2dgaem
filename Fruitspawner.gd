extends Node
var fruit_scene = preload('res://fruit.tscn')


func _ready() -> void:
	var fruit = fruit_scene.instantiate()
	fruit.my_custom_signal.connect(_on_yoinka)

func _process(delta: float) -> void:
	pass
	
func _on_yoinka():
	print("HAAAAAAAAAAAAAAAAAAAAH")

