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
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#hurtByEnemy(hurtBox)
			hurtByEnemy()
		#for area in hurtBox.get_overlapping_areas():
			#if area.name == "hitbox":
				#hurtByEnemy(area)
	
#func hurtByEnemy(area):
func hurtByEnemy():
	currentHealth -= 10 #enemyDamage
	if currentHealth < 0:
		currentHealth = maxHealth
	isHurt = true
	hurtTimer.start()
	await hurtTimer.timeout
	isHurt = false
	healthChanged.emit()

func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Open the menu if player presses escape
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://Main Menu/MainMenu.tscn")
	
	# Testing stuff, remove this later
	if position.y > 1000:
		# Reset the player if they fall off the world
		position = Vector2(0,0)
		velocity = Vector2(0,0)
	pass
