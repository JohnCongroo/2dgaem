extends CharacterBody3D

@onready var camera = $Camera3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const gravity = 20.0
const JUMP_VELOCITY = 14
@export var MAX_HEALTH = 10
const SPEED_NORMAL = 30
const SPEED_SPRINT = 30
const SHOOTING_DELAY = 0.07 #wass #0.07
const SPEED_DASH = 200
const DASH_LENGTH = 38
const DASH_SPEED = 0.26 #in seconds

var HEALTH = MAX_HEALTH
var INVULN = false
var canShoot = true  # Variable to control shooting delay
var SPEED = SPEED_NORMAL
var bulletinstance
var spread
const SPREAD_AMOUNT = 0.18
@onready var sceneChanger = get_parent().get_node("Scene_Changer")
var bullet = preload("res://bullet.tscn")

@onready var gunbarrel = $Camera3D/Gun/RayCast3D

func shoot():
	if canShoot:
		bulletinstance = bullet.instantiate()
		bulletinstance.position = gunbarrel.global_position + gunbarrel.global_transform.basis.z + spread
		bulletinstance.transform.basis = gunbarrel.global_transform.basis
		get_parent().add_child(bulletinstance)
		canShoot = false
		$ShotDelay.start()  # Start the timer for the delay

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SPEED = SPEED_NORMAL

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .0085)
		camera.rotate_x(-event.relative.y * .0085)

		
	if Input.is_action_just_pressed("left"):
		#camera.rotation.x = clamp(camera.rotation.x, 0, 0)tween.tween_property(camera, "rotation", camera.get_rotation() + Vector3(0,0,0.03), 0.15).set_trans(Tween.TRANS_SINE)		
		create_tween().tween_property(camera, "rotation", camera.get_rotation() + Vector3(0,0,0.035), 0.15).set_trans(Tween.TRANS_SINE)
		#tween.tween_callback(func(x): return clamp(camera.rotation.x, -PI/2, PI/2))
		#currently doesnty tilt if the direction nis already held while landing
	if Input.is_action_just_pressed("right"):
		create_tween().tween_property(camera, "rotation", camera.get_rotation() + Vector3(0,0, -0.035), 0.15).set_trans(Tween.TRANS_SINE)
	if Input.is_action_just_released("right") || Input.is_action_just_released("left"):
		create_tween().tween_property(camera, "rotation", camera.get_rotation() + Vector3(0,0,-camera.get_rotation().z), 0.15).set_trans(Tween.TRANS_SINE)

	camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	#camera.rotation.x = clamp(camera.rotation.x, -1.3, 1.3)
func _physics_process(delta):
	spread = Vector3(randf_range(-SPREAD_AMOUNT,SPREAD_AMOUNT),randf_range(-SPREAD_AMOUNT,SPREAD_AMOUNT),randf_range(-SPREAD_AMOUNT,SPREAD_AMOUNT))
	#create_tween().tween_property(camera, "rotation", Vector3(0,0,0), 0.2).set_trans(Tween.TRANS_CIRC)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#shoot()
	
	#if Input.is_action_pressed("sprint"):
	#	SPEED = SPEED_SPRINT
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	#shooting bullets
	if Input.is_action_pressed("shoot"):
		shoot()

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle double jump
	if Input.is_action_just_pressed("ui_accept") and !is_on_floor():
		velocity.y = JUMP_VELOCITY

	#if Input.is_action_pressed("sprint"):
	#	velocity += Vector3(1,0,0) * 300
		
	if direction && Input.is_action_just_pressed("sprint"):
		#global_position += direction * 100
		create_tween().tween_property(self, "global_position", global_position + direction * DASH_LENGTH, DASH_SPEED).set_trans(Tween.TRANS_CIRC)
		
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()

func _on_invuln_timer_timeout() -> void:
	INVULN = false
	
func getHealth() -> int:
	return HEALTH

func _on_hurtbox_area_entered(area: Area3D):
	if area.get_parent().get_parent().is_in_group("enemy") && INVULN == false:
		HEALTH -= 1
		$CanvasLayer/AnimationPlayer.play("hurt")
		create_tween().tween_property($CanvasLayer/ProgressBar, "value", HEALTH, 0.05)
		if HEALTH <= 0:
			HEALTH = 99
			sceneChanger.deathScreen() 
		$InvulnTimer.start()
		INVULN = true

func _on_dash_cooldown_timeout() -> void:
	pass
	#SPEED = SPEED_NORMAL

func _on_shot_delay_timeout() -> void:
	canShoot = true
