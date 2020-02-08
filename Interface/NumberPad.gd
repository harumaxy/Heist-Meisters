extends Popup

var combination: PoolIntArray = [0, 4, 5, 1]
var guess: PoolIntArray = []

onready var display = $VBoxContainer/DisplayContainer/Display
onready var status_light = $VBoxContainer/ButtonContainer/GridContainer/StatusLight

signal combination_correct



func set_combination(numbers):
	combination = numbers
	print(combination)

func _ready():
	display.text = ""
	connect_buttons()
	
	
func connect_buttons():
	for child in $VBoxContainer/ButtonContainer/GridContainer.get_children():
		if child is Button:
			child.connect("pressed", self, "Button_pressed", [child.text])


func Button_pressed(text):
	if text == "OK":
		check_guess()
	else:
		enter( int(text) )

	
func check_guess():
	if guess == combination:
		$AudioStreamPlayer.stream = load("res://Heist-Meisters-Assets/SFX/threeTone1.ogg")
		$AudioStreamPlayer.play()
		emit_signal("combination_correct")
		$AnimationPlayer.play("Correct")
	else:
		reset_lock()

func _on_AnimationPlayer_animation_finished(anim_name):
	hide()
	reset_lock()
	status_light.modulate = Color("fb7c02")
	
	

func enter(num):
	$AudioStreamPlayer.stream = load("res://Heist-Meisters-Assets/SFX/twoTone1.ogg")
	$AudioStreamPlayer.play()
	guess.append(num)
	update_display()

func update_display():
	display.text = PoolStringArray(Array(guess)).join("")
	if guess.size() == combination.size():
		check_guess()
	
func reset_lock():
	display.text = ""
	guess = []



