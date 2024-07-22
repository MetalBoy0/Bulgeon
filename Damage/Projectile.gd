extends "res://Damage/Hitbox.gd"

@export var Speed: int = 100

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += Speed * direction * delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
func destroy():
	queue_free()
func _on_area_entered(area):
	destroy()
func _on_body_entered(body):
	destroy()
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
