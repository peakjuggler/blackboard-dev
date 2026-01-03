extends VBoxContainer

@onready var child_count := 3
@onready var img_size =  50.0

var num = 0


func _ready():
	# duplicate first character to set him in front and back of carousel to create the effect
	var first_child = $".".get_child(0)
	var new_last_child = first_child.duplicate()
	$".".add_child(new_last_child)


# scroll te scrollcontainer when choosing an item
func noll(prev = 0, next = 0):
	var tween = create_tween()
	
	tween.tween_property($".".get_child(num), "position", Vector2.RIGHT * 300, 1.0).as_relative().set_trans(Tween.TRANS_SINE)
	num += 1
	
	if num >= 4:
		num = 0

func roll(prev = 0, next = 0):
	var tween = create_tween()
	var prev_pos
	print("1234")
	var next_pos
	prev_pos = prev*img_size
	next_pos = next*img_size
	if prev == child_count-1 and next == 0:
		next_pos = (prev+1)*img_size
	elif prev == 0 and next == child_count-1:
		prev_pos = (next+1)*img_size
	tween.tween_property($".".get_child(0), "position", Vector2.RIGHT * next_pos, 1.0).set_trans(Tween.TRANS_SINE)
