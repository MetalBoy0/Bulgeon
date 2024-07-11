extends CharacterBody2D

# Adjust these in the characterbody inpector
@export var maxSpeed: float
@export var acceleration: float 
@export var gravity: float
@export var jumpForce: float
@export var drag: float # Note: Currently drag only affects horizontal movement

# Called when the node enters the scene tree for the first time.

func _physics_process(delta):
	# Apply drag
	velocity.x /= (1+drag*delta)
	
	# Process inputs
	if Input.is_action_pressed("move_left"):
		velocity.x = max(velocity.x - acceleration, -maxSpeed) 
	elif Input.is_action_just_released("move_left"):
		velocity.x = 0
		
	if Input.is_action_pressed("move_right"):
		velocity.x = min(velocity.x + acceleration, maxSpeed)
	elif Input.is_action_just_released("move_right"):
		velocity.x = 0
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= jumpForce
		
	# Gravity
	if !is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
		
	

func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
