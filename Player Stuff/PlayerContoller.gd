extends CharacterBody2D

signal healthChanged

@export var maxSpeed: float = 500
@export var acceleration: float = 50; 
@export var gravity: float = 1000
@export var jumpForce: float = 500
@export var maxHealth: int;
@onready var currentHealth: int = maxHealth
@export var hurtBox: CollisionShape2D
@export var hurtTimer: Timer

var isHurt: bool = false

# Called when the node enters the scene tree for the first time.

func _physics_process(delta):
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
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://Main Menu/MainMenu.tscn")
