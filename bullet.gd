extends Area2D

@export var speed = 800
var slowed_speed = speed * 0.05
#var slow = 100

func _physics_process(delta):
	position += transform.x * speed * delta
	
	if Global.comingOutOfSandy == true && Global.globalSandyActive == true:
		create_tween().tween_property($".", "speed", 0, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if Global.globalSandyActive == true && !Global.comingOutOfSandy == true:
		create_tween().tween_property($".", "speed", slowed_speed, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if Global.globalSandyActive == false:
		create_tween().tween_property($".", "speed", 800, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func _on_bullet_body_entered(body):
	if body.has_method("shot"):
		print("cool!")
		body.shot()
