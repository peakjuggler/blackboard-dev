extends CanvasGroup

var player
var speedLimitTxt := ""
var low := " SLOW"
var med := " NORMAL"
var high := " BOOST"
var gearNum := 2
var hasBeenCalled := false
var timerHasBeenCalled := false
#create_tween().tween_property(warningBox, "modulate:a", 1, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
@onready var warningBox := $alertBox
@onready var sandyTimer = get_owner().get_node("player/sandevistan")
@onready var sandyCooldown = get_owner().get_node("player/sandCool")
@onready var alpha_tween: Tween = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_owner().get_node("player")
	pass
	
func _on_warning_timeout() -> void:
	create_tween().tween_property(warningBox, "modulate:a", 0, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	pass # Replace with function body.
	
func update_sand():
	var maxTime = $SAND.max_value
	$SAND.value = sandyTimer.time_left
	pass
	
func update_boost():
	$BOOST.max_value = player.max_boost_legnth
	var maxTime = $BOOST.max_value
	$BOOST.value = player.boostLength
	pass
	
func reset_HUD_alpha():
	create_tween().tween_property($".", "modulate:a", 1, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	pass

func set_HUD_alpha():
	create_tween().tween_property($".", "modulate:a", 0, 0.3).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	pass	
	
func idle_cooldown():
	if !player.canUseSandy:
		$SAND.value = ( sandyCooldown.wait_time - sandyCooldown.time_left ) / 4
	pass					   
	
func update_speed():
	var currentSpeed = 0 + player.current_speed
	var decimalSpeed = snapped(currentSpeed, 0.1)
	$SPEED.text = ("SPEED : " + str(decimalSpeed))
	pass

func warning():
	print("meow")
	hasBeenCalled = true;
	
	if is_instance_valid(alpha_tween):
		alpha_tween.kill()
		
	alpha_tween = create_tween().set_loops()
	alpha_tween.tween_property($alertBox, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	alpha_tween.tween_interval(0.2)
	alpha_tween.tween_property($alertBox, "modulate:a", 0.0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	alpha_tween.tween_interval(0.2)
	
func update_limit():
	
	if gearNum < 1:
		gearNum = 1
		
	if gearNum > 3:
		gearNum = 3  
	
	match gearNum:
		1:
			speedLimitTxt = low
		2:
			speedLimitTxt = med
		3:
			speedLimitTxt = high
	
	$LIMIT.text = ("MODE : " + str(speedLimitTxt))
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	update_speed()
	update_limit()
	update_boost()
	
	if player.boostLength < 1.25 && hasBeenCalled == false:
		warning()
	if player.boostLength > 1.25:
		create_tween().tween_property(warningBox, "modulate:a", 0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		#alpha_tween.kill()	
	if player.sandyActive == true:
		set_HUD_alpha()
		update_sand()
	if !player.sandyActive || ( player.boostActive && !player.sandyActive ):
		reset_HUD_alpha()
		idle_cooldown()
	
func _on_player_speed_up() -> void:
	gearNum += 1
	print("houngry")
	pass # Replace with function body.
	
func _on_player_speed_down() -> void:
	gearNum -= 1
	print("starving")
	pass # Replace with function body.
