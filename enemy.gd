extends CharacterBody2D
@onready var t = $"../player"
@onready var color_tween: Tween = null

@export var speed = 1000
@export var health = 3


func _physics_process(delta: float):
	var direction = (t.position - position).normalized()
	velocity = direction * speed
	move_and_slide()
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("enemy health is : ", health)
	
	hurt_tween()
	
	health -= 1
	if health <= 0:
		queue_free()
	
func hurt_tween():
	color_tween = create_tween().set_loops(1)
	color_tween.tween_property($tri, "modulate:s", 1.0, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	color_tween.tween_property($".", "speed", speed, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	color_tween.tween_interval(0.1)
	color_tween.tween_property($tri, "modulate:s", 0.0, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	color_tween.tween_property($".", "speed", speed, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	color_tween.tween_interval(0.1)
