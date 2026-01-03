extends Area2D

@export var speed = 1250
#var slow = 100

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_bullet_body_entered(body):
	if body.has_method("shot"):
		print("cool!")
		body.shot()
