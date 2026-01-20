extends CharacterBody2D

var speed: float = 100.0
var current_speed = 100	 # elusive penis variable
var acceleration = 45	# game var acceleration

@export_category("Movement")
@export var base_acceleration = 45	# the acceleration that gets used to multiply boost power
@export var base_top_speed: float = 1075.0
@export var speed_penalty: float = 775.0

@export_category("Attributes")
@export var boostLength := 3.0 # if you change one make sure to change the other!!!
@export var max_boost_legnth = 3.0

@export_category("Weapons")
@export var Bullet : PackedScene
@export var bullet_speed:int = 800

@export_category("Time")
@export var default_time_scale = 1
@export var sandevistan_time_scale = 0.5

var limitNum := 2
var gearBefore := 2

var canUseSandy := true
var sandyActive := false
var boostActive := false
var penalty := false

@onready var engine_time_tween: Tween = null
@onready var camera_tween: Tween = null

signal hit
signal speedUp
signal speedDown

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = default_time_scale
	reset_camera_speed() # if this isnt here the camera is way more floatier than usual??? 
	pass
	
func _physics_process(delta):
	var inputVector := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	velocity += (inputVector) * ( speed * delta * acceleration)
	velocity = velocity.limit_length(base_top_speed)
	current_speed = velocity.length()
	
	print(acceleration)
	
	if (penalty && boostLength >= 1.30):
		penalty = false
		
	if ( Input.is_action_just_pressed("SANDY") && canUseSandy && !sandyActive && !boostActive ):
		on_activateSandy()
		
	if ( Input.is_action_pressed("BOOST") && !sandyActive && penalty == false):
		on_boost()
				
	if boostLength > max_boost_legnth:
		boostLength = max_boost_legnth
	
	if boostLength < 0:
		acceleration /= 3 # 5 made my one playtester want to kill themselves so 3 it is
		base_top_speed = lerp(base_top_speed, speed_penalty, 1)
		movement_penalty()
		
	if Input.is_action_just_pressed("LMB"):
		on_fire()
		
	if ( Input.is_action_just_released("BOOST") && !penalty ):
		acceleration = base_acceleration
		limitNum -= 1
		speedDown.emit()
		boostActive = false
		$boostTrail.emitting = false
	
	if ( Input.is_action_just_released("BOOST") && !sandyActive ):
		if is_instance_valid(camera_tween):
			camera_tween.kill()
		camera_tween = create_tween()
		#$Camera2D.position_smoothing_enabled = true
		camera_tween.tween_property($Camera2D, "zoom", Vector2(0.4, 0.4), 2).set_ease(Tween.EASE_OUT)
		
		reset_camera_speed()
		
		
	if boostActive == false && current_speed > 1025:
		if boostLength < 1:
			boostLength += 0.01
		else:
			boostLength += 0.0075
		#print("boost 000")
		
	if inputVector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 5)	
		
	match limitNum:
		1:
			on_firstGear()

		2:
			on_secondGear()

		3:
			on_thirdGear()

			
	if limitNum < 1:
		limitNum = 1
		
	if limitNum > 3:
		limitNum = 3  

	
	
	move_and_slide()
	
func on_fire() -> void:
	var b = Bullet.instantiate()
	b.speed = bullet_speed
	owner.add_child(b)
	b.transform = $weapon/hitmarker.global_transform
	#print("fuck")

func reset_camera_speed() -> void:
	$Camera2D.position_smoothing_speed = 17.5

func on_activateSandy() -> void:
	$Camera2D.position_smoothing_speed = 25
	sandyActive = true
	speedDown.emit()
	
	bullet_speed = 50

	if is_instance_valid(engine_time_tween):
		engine_time_tween.kill()
	engine_time_tween = create_tween()
	engine_time_tween.tween_property(Engine, "time_scale", sandevistan_time_scale, 0.5) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
	if is_instance_valid(camera_tween):
		camera_tween.kill()
	camera_tween = create_tween()
	camera_tween.tween_property($Camera2D, "zoom", Vector2(0.42, 0.42), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	$GPUParticles2D.lifetime = 3.5
	$GPUParticles2D.emitting = true
	
	#sandevistanLength = lerpf(12.0, 0.0, 0.5)
	$sandevistan.start()
	
func movement_penalty():
	speedDown.emit()
	#acceleration / 2 
	boostLength = 0 
	boostActive = false
	$boostTrail.emitting = false
	penalty = true
	
func on_boost() -> void:
	if is_instance_valid(camera_tween):
		camera_tween.kill()
	camera_tween = create_tween()
	#$Camera2D.position_smoothing_speed = 11.75
	camera_tween.tween_property($Camera2D, "zoom", Vector2(0.39, 0.39), 0.05).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	#camera_tween.tween_property($Camera2D, "position_smoothing_speed", 1, 0.05).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	
	base_top_speed *= 1.05
	acceleration = base_acceleration * 1.5
	
	if base_top_speed > 1800:
		base_top_speed = 1800	
		
	if boostLength <= 1.5:
		#$Camera2D.position_smoothing_speed = 10
		base_top_speed *= 1.15
		
	$boostTrail.emitting = true
	boostActive = true
	boostLength -= 0.025
	speedUp.emit()
	limitNum += 1

func _on_body_entered(_body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func on_firstGear() -> void:
	base_top_speed = lerp(base_top_speed, speed_penalty, 0.0075)

func on_secondGear() -> void:
	base_top_speed = lerp(base_top_speed, 1075.0, 0.025)

func on_thirdGear() -> void:
	base_top_speed = lerp(base_top_speed, 1075.0, 0.025)
	
func _on_sandevistan_timeout() -> void:
	$sandTrans.start()		
	if is_instance_valid(camera_tween):
		camera_tween.kill()
	camera_tween = create_tween()
	camera_tween.tween_property($Camera2D, "zoom", Vector2(0.38, 0.38), 1.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	base_top_speed = 0.0
	speed = 0
	$GPUParticles2D.lifetime = 1.5
	print ("im fuckingh workuing")
	$GPUParticles2D.emitting = false

func _on_sand_trans_timeout() -> void:
	$sandCool.start()
	speed = 100.0
	
	sandyActive = false
	#bad. this is fucking awful
		
	engine_time_tween = create_tween()
	engine_time_tween.tween_property(Engine, "time_scale", default_time_scale, 0.5) \
		.set_trans(Tween.TRANS_LINEAR).from_current()
	
	if is_instance_valid(camera_tween):
		camera_tween.kill()
	camera_tween = create_tween()
	camera_tween.tween_property($Camera2D, "zoom", Vector2(0.4, 0.4), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		
	canUseSandy = false
	speedUp.emit()
	$GPUParticles2D.lifetime = 3.5
	
	bullet_speed = 800

func _on_sand_cool_timeout() -> void:
	print("yay!")
	canUseSandy = true
