extends CharacterBody2D
@onready var t = $"../player"
@onready var s = $Sandevistan
@onready var color_tween: Tween = null

@export var speed = 0
@export var base_speed = 1200
@export var health = 100

var sandyAlreadyActive = false


func _physics_process(delta: float):
	var direction = (t.position - position).normalized()
	velocity = direction * speed
	
	move_and_slide()
	check_for_sandevistan()
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Projectile_Bullet:
		print("boss health is : ", health)
		hurt_tween()
		health -= 1
	
	if area is PLAYERCB && t.current_speed > 1200 :
		print("boss health is : ", health)
		hurt_tween()
		health -= 10
	
	if health <= 0:
		queue_free()
		
func check_for_sandevistan():
	if Global.comingOutOfSandy == true && Global.globalSandyActive == true:
		sandevistan_rtrt()
	if Global.globalSandyActive == true && !Global.comingOutOfSandy == true:
		sandevistan_init()
	if Global.globalSandyActive == false:
		create_tween().tween_property($".", "speed", base_speed, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func sandevistan_init(): 
	create_tween().tween_property($".", "speed", 1000, 0.01).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	s.lifetime = 3.5
	s.emitting = true

func sandevistan_rtrt(): # RTRT : Return to real time 
	create_tween().tween_property($".", "speed", 0, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	s.lifetime = 1.5
	s.emitting = false

func hurt_tween():
	color_tween = create_tween().set_loops(1)
	color_tween.tween_property($ThebigE, "modulate:s", 1.0, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	color_tween.tween_interval(0.1)
	color_tween.tween_property($ThebigE, "modulate:s", 0.0, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	color_tween.tween_interval(0.1)
