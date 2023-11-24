extends Node
@onready var fruit_scene = preload('res://fruit.tscn')
@onready var player = get_node("Player")

func _ready() -> void:
	if player:
		player.spawn_fruit.connect(_on_player_spawn_fruit)
	
func _process(delta: float) -> void:
	pass
	
func _on_player_spawn_fruit() -> void:
	var fruit = fruit_scene.instantiate()
	fruit.join.connect(_on_fruit_join)
	fruit.position = player.get_child(0).global_position
	fruit.add_to_group('fruit1')
	get_parent().add_child(fruit)  
	
func _on_fruit_join(body: Node) -> void:
	call_deferred("_spawn_fruit_after_join", body)

func _spawn_fruit_after_join(body: Node) -> void:
	var fruit = fruit_scene.instantiate()
	fruit.join.connect(_on_fruit_join)
	fruit.position = body.global_position
	fruit.fruititeration += 1
	fruit.add_to_group('fruit' + str(fruit.fruititeration))
	body.get_parent().queue_free()
	get_parent().add_child(fruit)
