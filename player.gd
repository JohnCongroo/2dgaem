extends Node2D
const SPEED = 250
@onready var body = $CharacterBody2D
@onready var player = $CharacterBody2D/AnimatedSprite2D
var fruit = preload('res://fruit.tscn')
signal spawn_fruit
signal hold_fruit

func _ready() -> void:
	player.play('idle')

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("hold"):
		emit_signal('hold_fruit')
	
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal('spawn_fruit')
		
		if Input.is_action_just_pressed("escape"):
			get_tree().quit()
			
	
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = Vector2(input_dir.x, input_dir.y)
	
	if direction:
		body.velocity.x = direction.x * SPEED
		#body.velocity.y = direction.y * SPEED
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, SPEED)
		#body.velocity.y = move_toward(body.velocity.y, 0, SPEED)
		
	if Input.is_action_just_pressed("mouse_left"):
		body.global_position.x = get_global_mouse_position().x
		emit_signal('spawn_fruit')
		
		
	clamp(body.velocity.x, 0, 0)
	body.move_and_slide()


	#	if Input.is_action_just_pressed('up'):
#		position.y -= 50
#	if Input.is_action_just_pressed('down'):
#		position.y += 50
#	if Input.is_action_just_pressed('left'):
#		position.x -= 50
#
#	if Input.is_action_just_pressed('right'):
#		position.x += 50	
		
