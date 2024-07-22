extends TextureProgressBar

@export var player: CharacterBody2D
@export var camera: Camera2D
@export var offset: Vector2
# Changes health bar based on current health
func update():
	value = player.currentHealth * 100 / player.maxHealth
# Connects to healthChanged function in Player Controller
func _ready():
	player.healthChanged.connect(update)
	update()
# Gets position where health bar should be.
func _process(_delta):
	position = camera.get_screen_center_position() - camera.get_viewport_rect().size / 2 + offset
