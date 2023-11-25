extends Node

var joiners = []
var fruit_scene = preload('res://fruit.tscn')
var held
var next

@onready var player = get_node("Player")

func _ready() -> void:

	#next = spawnFruit(Vector2(1220,200), randi_range(1,5))
	if player:
		player.spawn_fruit.connect(_on_player_spawn_fruit) 
		player.hold_fruit.connect(_on_player_hold_fruit)
		next = spawnFruit(Vector2(1000,100), randi_range(1,5))
		
		
func _process(delta: float) -> void:
	pass
	
func _on_player_hold_fruit() -> void:
	pass
	
func _on_player_spawn_fruit() -> void:
	var playerPosition = player.get_child(0).global_position
	spawnFruit(playerPosition, next.fruititeration)	
	get_child(2).get_child(3).visible = false
	get_child(2).get_child(3).get_child(0).disabled = true
	get_child(1).get_child(1).get_child(0).start()
	print('timers tarted?')
	next = spawnFruit(Vector2(1000,100), randi_range(1,5))

func _on_fruit_join(body: Node) -> void:
	call_deferred("_spawn_fruit_after_join", body)

func _spawn_fruit_after_join(body: Node) -> void:
	joiners.append(body)
	if joiners.size() % 2 == 0:
		var fruit = fruit_scene.instantiate()
		var bodyFruit = body.get_parent()
		var spawnLocation = Vector2((joiners[0].global_position.x + joiners[1].global_position.x)/2,(joiners[0].global_position.y + joiners[1].global_position.y)/2)
		spawnFruit(spawnLocation, bodyFruit.fruititeration + 1)	
		joiners.clear()
			
func spawnFruit(location: Vector2, iteration: int):	
	var fruit = fruit_scene.instantiate()
	var label = fruit.get_child(0).get_child(1)
	var group = 'fruit' + str(iteration)
	var mesh = fruit.get_child(0).get_child(0).get_child(0)
	var collision = fruit.get_child(0).get_child(0)
	#print(fruit, position, iteration)
	fruit.join.connect(_on_fruit_join)
	fruit.fruititeration = iteration
	fruit.global_position = location
	label.text = str(iteration)
	fruit.add_to_group(group)
	mesh.set_modulate(Color(iteration * 0.15,0.5,0.3, 0.8))
	collision.scale += iteration * 0.5 * Vector2(0.25,0.25)
	get_parent().add_child.call_deferred(fruit)
	return fruit


func _on_ghetto_timeout() -> void:
	get_parent().get_parent().get_child(2).get_child(3).visible = true
	get_parent().get_parent().get_child(2).get_child(3).get_child(0).disabled = false

