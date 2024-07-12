extends "PlayerAttacks.gd"

signal healthChanged

@export var maxHealth: int;
@onready var currentHealth: int = maxHealth
@export var hurtBox: CollisionShape2D
@export var hurtTimer: Timer


var isHurt: bool = false
# DO NOT EDIT VALUES HERE
# Edit them in the CharacterBody2D properties

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	
# Runs every physics tick
func _physics_process(delta):
	# delta is how long it has been since the previous tick (in seconds)
	
	# Process move inputs
	handle_attacks(delta)
	handle_move(delta)
	
			
	# Gravity
	if !is_on_floor() and (!isRolling or !isGroundPound):
		velocity.y += gravity * delta
		
	move_and_slide() # Send movements to physics engine
	
	
	if !isHurt:
		var collision: KinematicCollision2D = move_and_collide(velocity * delta)
		if collision:
			if collision.get_collider().name == "Enemy":
				hurtByEnemy()
		#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#hurtByEnemy(hurtBox)
			#hurtByEnemy(area))
	
#func hurtByEnemy(area):
func hurtByEnemy():
	currentHealth -= 10 #enemyDamage
	if currentHealth < 0:
		get_tree().change_scene_to_file("res://Menus/Death Menu/DeathMenu.tscn")
	healthChanged.emit()
	isHurt = true
	#hurtTimer.start()
	#await hurtTimer.timeout
	isHurt = false
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://Menus/Main Menu/MainMenu.tscn")
	# Testing stuff, remove this later
	if position.y > 1000:
		# Reset the player if they fall off the world
		position = Vector2(0,0)
		velocity = Vector2(0,0)
	pass
