extends TextureProgressBar

@export var player: CharacterBody2D
@export var camera: Camera2D
@export var offset: Vector2
func update():
	value = player.currentHealth * 100 / player.maxHealth
# Called when the node enters the scene tree for the first time.
func _ready():
	player.healthChanged.connect(update)
	update()
# Gets position where health bar should be.
func _process(delta):
	position = camera.get_screen_center_position() - camera.get_viewport_rect().size / 2 + offset
