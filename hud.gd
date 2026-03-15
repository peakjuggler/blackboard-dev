extends CanvasGroup

var player

var speedLimitTxt: String = ""
var low: String = " SLOW"
var med: String = " NORMAL"
var high: String = " BOOST"
var text: String = "coolant temp                    "

var temptature: float

var gearNum: int = 2

var hasBeenCalled: bool = false
var timerHasBeenCalled: bool = false

var baseColor = Color(1, 1, 1, 1)
var redTweenColor = Color(0.966, 0.182, 0, 1)
var yellowTweenColor = Color(1, 1, 0, 1)

@onready var warningBox: Node2D = $BoostBar
@onready var coolantTemp: Label = $BoostBar/coolantTemp
@onready var boostBar: ProgressBar = $BoostBar/BOOST
@onready var sandyTimer = get_owner().get_node("player/sandevistan")
@onready var sandyCooldown = get_owner().get_node("player/sandCool")
@onready var alpha_tween: Tween = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_owner().get_node("player")
	pass
	
func update_sand():
	$SAND.value = sandyTimer.time_left
	pass
	
func update_boost():
	boostBar.max_value = player.max_boost_legnth
	temptature = snapped((player.max_boost_legnth + 1) - player.boostLength, 0.1)
	boostBar.value = player.boostLength
	coolantTemp.text = (text + str(100 * temptature)+ " F*")
	pass
	
func reset_HUD_alpha():
	create_tween().tween_property($".", "modulate:a", 1, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	pass

func reset_BoostBar_color():
	create_tween().tween_property(warningBox, "modulate", baseColor, 0.1).set_trans(Tween.TRANS_SINE)
	pass

func set_HUD_alpha():
	create_tween().tween_property($".", "modulate:a", 0, 10).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	pass	
	
func idle_cooldown():
	if !player.canUseSandy:
		$SAND.value = ( sandyCooldown.wait_time - sandyCooldown.time_left ) / 4
	pass 
	
func update_speed():
	var currentSpeed = 0 + player.current_speed
	var decimalSpeed = snapped(currentSpeed, 1)
	$SPEED.text = (str(decimalSpeed / 35) + " M/s")
	pass
	
func warning():
	print("meow")
	hasBeenCalled = true;
	
	if is_instance_valid(alpha_tween):
		alpha_tween.kill()
		
	alpha_tween = create_tween().set_loops()
	alpha_tween.tween_property(warningBox, "modulate", redTweenColor, 0.1).set_trans(Tween.TRANS_SINE)
	alpha_tween.tween_interval(0.1)
	alpha_tween.tween_property(warningBox, "modulate", baseColor, 0.3).set_trans(Tween.TRANS_SINE)
	alpha_tween.tween_interval(0.1)
	
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
func _process(_delta: float) -> void:
	
	update_speed()
	update_limit()
	update_boost()
		
	if player.boostLength < 1.25 && hasBeenCalled == false:
		warning()
	if player.boostLength > 1.25 && hasBeenCalled == true:
		reset_BoostBar_color()
	if player.sandyActive == true:
		set_HUD_alpha()
		update_sand()
	if !player.sandyActive || ( player.boostActive && !player.sandyActive ):
		reset_HUD_alpha()
		idle_cooldown()
	
func _on_player_speed_up() -> void:
	gearNum += 1
	pass
	
func _on_player_speed_down() -> void:
	gearNum -= 1
	pass
