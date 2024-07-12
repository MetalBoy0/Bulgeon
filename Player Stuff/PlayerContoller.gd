extends CharacterBody2D

signal healthChanged

@export var maxHealth: int;
@onready var currentHealth: int = maxHealth
@export var hurtBox: CollisionShape2D
@export var hurtTimer: Timer

var isHurt: bool = false
# DO NOT EDIT VALUES HERE
# Edit them in the CharacterBody2D properties
@export_category("Movement")
@export var maxSpeed: float
@export var acceleration: float 
@export var jumpForce: float
@export var drag: float # Note: Currently drag only affects horizontal movement

@export_category("Attacks")

@export_group("Roll")
@export var maxRollHoldDuration: float # The maximum duration to hold when charging a roll
@export var minRollHoldDuration: float # The minimum duration to hold when charging a roll
@export var maxRollDuration: float # The maximum duration a roll lasts
@export var rollSpeed: float # How fast the roll is







var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Generic player stuff
var isMoving: bool = false
var isChargingAttack: bool = false # Is player charging up an attack
var isDoingAttack: bool = false
var lastDir: float = 1 # The last direction the player moved, used for deciding which way to roll

# Roll information
var isRolling: bool = false
var currentRollHold = 0; # How long the player has been charging roll
var currentRollDur = 0; # How long the player has been rolling
var finishRollDur = 0; # How long the current roll will last
var rollDirection = 0;

func handle_attacks(delta: float):
	
	
	if !isRolling:
		# Charging roll
		if Input.is_action_just_pressed("roll_attack"):
			isChargingAttack = true
			velocity.x = 0
			
		if Input.is_action_pressed("roll_attack"):
			# Count seconds that player is charging
			currentRollHold += delta
			
			# Also monitor the player keypresses to find the direction of roll
			var dir = Input.get_axis("move_left","move_right")
			if dir:
				# If direction isn't zero (player has pressed move key)
				lastDir = dir
		else:
			isChargingAttack = false
			
		# Player releases roll button to attack
		if Input.is_action_just_released("roll_attack") and currentRollHold > minRollHoldDuration:
			# Find out how long to roll
			finishRollDur = min(maxRollDuration, currentRollHold/maxRollHoldDuration * maxRollDuration)
			

			isRolling = true
			isDoingAttack = true
			currentRollHold = 0
			
			rollDirection = Input.get_axis("move_left","move_right") # Get the direction the player wants to move
			
			# If the player isn't pressing any buttons
			# Use the last direction for where to roll
			if rollDirection == 0:
				rollDirection = lastDir
			
			# Set the last moved direction to the direction the player rolls
			lastDir = rollDirection
			
			
	else:
		# This part runs if the player is currently rolling
		velocity.x = rollSpeed * rollDirection # Set player velocity to the roll speed
		velocity.y = 0
		
		currentRollDur += delta # Update roll duration
		
		# If player finishes roll attack
		if currentRollDur > finishRollDur:
			currentRollDur = 0
			isRolling = false
			isDoingAttack = false
			velocity.x = 0
	
# Runs every physics tick
func _physics_process(delta):
	# delta is how long it has been since the previous tick (in seconds)
	
	# Process move inputs
	
	# Prevent player from moving when charging an attack or preforming an attack
	if !isChargingAttack and !isDoingAttack:
		
		# Apply drag only if the player isn't pressing move buttons
		if !isMoving:
			velocity.x /= (1+drag*delta)
			
		
		# Horizontal player movement
		var direction = Input.get_axis("move_left","move_right")
		
		# If the player is pressing move_left or move_right buttons
		if direction:
			# Update velocity
			# Move toward increments the velocity by acceleration while also maxing it at maxSpeed
			velocity.x = direction*min(maxSpeed, abs(velocity.x)+acceleration)
			# Update last dir variable
			isMoving = true
			lastDir = direction
		else:
			isMoving = false
		
		# Player jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y -= jumpForce
		
	handle_attacks(delta)
			
	# Gravity
	if !is_on_floor() and !isRolling:
		velocity.y += gravity * delta
	move_and_slide()
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
