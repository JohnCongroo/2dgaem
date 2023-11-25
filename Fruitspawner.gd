extends Node
var joiners = []
@onready var player = get_node("Player")
var fruit_scene = preload('res://fruit.tscn')
func _ready() -> void:
	if player:
		player.spawn_fruit.connect(_on_player_spawn_fruit)
	
func _process(delta: float) -> void:
	pass
	
func _on_player_spawn_fruit() -> void:

	var fruit = fruit_scene.instantiate()
	fruit.join.connect(_on_fruit_join)
	fruit.position = player.get_child(0).global_position
	fruit.fruititeration = randi_range(1,5)
	var group = 'fruit' + str(fruit.fruititeration)
	fruit.get_child(0).get_child(1).text = str(fruit.fruititeration)
	fruit.add_to_group(group)
	fruit.get_child(0).get_child(0).get_child(0).set_modulate(Color(fruit.fruititeration * 0.2,fruit.fruititeration* 0.6,fruit.fruititeration* 0.2,1))
	fruit.get_child(0).get_child(0).scale = fruit.fruititeration * Vector2(0.25,0.25)
	get_parent().add_child(fruit)  
	
func _on_fruit_join(body: Node) -> void:
	call_deferred("_spawn_fruit_after_join", body)

func _spawn_fruit_after_join(body: Node) -> void:
	joiners.append(body)
	if joiners.size() % 2 == 0:
		var spawnlocation = Vector2((joiners[0].global_position.x + joiners[1].global_position.x)/2,(joiners[0].global_position.y + joiners[1].global_position.y)/2)
		var fruit = fruit_scene.instantiate()
		fruit.join.connect(_on_fruit_join)
		fruit.position = spawnlocation
		fruit.fruititeration = body.get_parent().fruititeration + 1
		fruit.get_child(0).get_child(0).get_child(0).set_modulate(Color(fruit.fruititeration * 0.2,fruit.fruititeration* 0.6,fruit.fruititeration* 0.2,1))
		fruit.get_child(0).get_child(0).scale = body.get_child(0).scale + Vector2(0.25,0.25)
		fruit.get_child(0).get_child(1).text = str(fruit.fruititeration)
		fruit.add_to_group('fruit' + str(fruit.fruititeration))
		print(fruit.get_groups())
		get_parent().add_child(fruit)
		joiners.clear()
