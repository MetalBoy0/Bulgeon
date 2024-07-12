extends "PlayerMoves.gd"

@export_category("Attacks")

@export_group("Roll")
@export var maxRollHoldDuration: float # The maximum duration to hold when charging a roll
@export var minRollHoldDuration: float # The minimum duration to hold when charging a roll
@export var maxRollDuration: float # The maximum duration a roll lasts
@export var rollSpeed: float # How fast the roll is

@export_group("Groundpound")
@export var groundPoundSpeed: float
@export var groundPoundMaxDur: float

# Roll information
var isRolling: bool = false
var currentRollHold = 0; # How long the player has been charging roll
var currentRollDur = 0; # How long the player has been rolling
var finishRollDur = 0; # How long the current roll will last
var rollDirection = 0;

# Groundpound information
var isGroundPound = false
var currentGroundPoundDur = 0


func handle_attacks(delta: float):
	
	
	if !isRolling and !isDoingAttack:
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
			
			
		# Player releases roll button after holding it long enough
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
	
	elif isRolling:
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
		
	if !isGroundPound and !isDoingAttack and !isChargingAttack:
		
		# Activate groundpound if the player is in the air and not already performing an attack
		if Input.is_action_just_pressed("groundpound_attack") and !is_on_floor():
			isGroundPound = true
			isDoingAttack = true
			currentGroundPoundDur = 0
	
	elif isGroundPound:
		# Player is currently groundpounding
		velocity.x = 0
		velocity.y = groundPoundSpeed
		
		# Player finishes roll attack
		if currentGroundPoundDur > groundPoundMaxDur or is_on_floor():
			isGroundPound = false
			isDoingAttack = false
		
		currentGroundPoundDur += delta

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
