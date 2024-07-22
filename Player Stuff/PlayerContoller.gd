extends "PlayerAttacks.gd"

signal healthChanged

@export_category("Health & Defense")
@export var maxHealth: int;
@onready var currentHealth: int = maxHealth
@export var hurtBox: CollisionShape2D
@onready var hurtTimer = $HurtTimer
@onready var hurtbox = $Hurtbox
@export var defense: int;
@export var receives_knocback: bool;
@export var knockback_modifier: float;
var isHurt: bool = false
# DO NOT EDIT VALUES HERE
# Edit them in the CharacterBody2D properties

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	
# Runs every physics tick
func _physics_process(delta: float):
	# delta is how long it has been since the previous tick (in seconds)
	
	# Process move inputs
	handle_attacks(delta)
	handle_move(delta)
	
			
	# Gravity
	if !is_on_floor() and (!isRolling or !isGroundPound):
		velocity.y += gravity * delta
		
	move_and_slide() # Send movements to physics engine
	

func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("escape"): # If escape is pressed
		get_tree().change_scene_to_file("res://Menus/Main Menu/MainMenu.tscn") # Go to main menu
	# Testing stuff, remove this later
	if position.y > 1000:
		# Reset the player if they fall off the world
		position = Vector2(1000,0)
		velocity = Vector2(0,0)
	pass

func receive_damage(base_damage: int):
	var actual_damage = base_damage
	actual_damage -= defense
	
	currentHealth -= actual_damage
	return actual_damage
func receive_knockback(damage_source_pos: Vector2, received_damage: int):
	if receives_knocback:
		var knockback_direction = damage_source_pos.direction_to(global_position)
		var knockback_strength = received_damage * knockback_modifier
		var knockback = knockback_direction * knockback_strength
		
		velocity = knockback
		velocity.y = velocity.y - 200
func _on_hurtbox_area_entered(hitbox):
	if hitbox.is_in_group("Projectile"):
		hitbox.destroy()
	if !isHurt:
		if !invincible:
			var actual_damage = receive_damage(hitbox.damage)
			if currentHealth == 0: # If health is equals 0
				get_tree().change_scene_to_file('res://Menus/Death Menu/DeathMenu.tscn') #Go to death screen if die
			healthChanged.emit() #Tell health bar that health has been reduced
			receive_knockback(hitbox.global_position, actual_damage)
			
			isHurt = true #Stop damage happening
			hurtTimer.start() #Start timer where no damage can occur
			await hurtTimer.timeout #When timer ends
			isHurt = false #Allow damage to happen
	#if !invincible:

	
