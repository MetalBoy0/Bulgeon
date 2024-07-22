extends CharacterBody2D
var EnemyCollison: bool = false
@onready var player = %Player
@onready var hurtbox = $Hurtbox
@export var defense: int;
@export var receives_knocback: bool;
@export var knockback_modifier: float;
@export var maxHealth: int;
@onready var currentHealth: int = maxHealth
@export var hurtBox: CollisionShape2D
@export var drag: float # Note: Currently drag only affects horizontal movement
@export var Projectile: PackedScene = preload("res://Damage/Projectile.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var damage: float
@onready var projectileTimer = $ProjectileTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	velocity.x /= (1+drag*delta)
	
	move_and_slide()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	#if position.x < -1000:
		#velocity.x = 100
	#elif position.x > -1000:
		#velocity.x = -100
	#projectileTimer.start() #Start timer where no damage can occur
	#await projectileTimer.timeout #When timer ends
	if (projectileTimer.is_stopped()):
		var projectile_direction = global_position.direction_to(player.global_position)
		throw_projectile(projectile_direction)
	move_and_slide()
	
func throw_projectile(projectile_direction: Vector2):
	if Projectile:
		var projectile = Projectile.instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = global_position
		
		var projectile_rotation = projectile_direction.angle()
		projectile.rotation = projectile_rotation
		projectileTimer.start() #Start timer where no damage can occur
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
	if player.invincible:
		var actual_damage = receive_damage(hitbox.damage)
		print(currentHealth)
		if currentHealth == 0: # If health is equals 0
			currentHealth = maxHealth
			position = Vector2(0,0)
			velocity = Vector2(0,0)
		receive_knockback(hitbox.global_position, actual_damage)
