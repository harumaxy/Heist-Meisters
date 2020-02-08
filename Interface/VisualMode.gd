extends CanvasModulate

# Level Sceneと疎結合にするために、"Interface" Groupに登録


# Cool Down Time
	# Timerはoneshot
	# 
const DARK = Color("111111")
const NIGHTVISION = Color("37bf62")

var is_cooling = false

func _ready():
	visible = true 	# 暗すぎると、エディタで見えなくなるので、エディタ false -> 実行時 true にする
	color = DARK
	get_tree().call_group("Labels", "hide")

# Vision Modeの切り替え
# Group通信から呼び出す
func cycle_vision_mode():
	if color == NIGHTVISION:
		DARK_mode()
		get_tree().call_group("Labels", "hide")
		$ActiveTimer.stop()
		$CooldownTimer.start(3)
	elif not is_cooling:
		NIGHTVISION_mode()
		get_tree().call_group("Labels", "show")
		$ActiveTimer.start(3)
		
	


func DARK_mode():
	color = DARK
	$AudioStreamPlayer.stream = load("res://Heist-Meisters-Assets/SFX/nightvision_off.wav")
	$AudioStreamPlayer.play()

func NIGHTVISION_mode():
	color = NIGHTVISION
	$AudioStreamPlayer.stream = load("res://Heist-Meisters-Assets/SFX/nightvision.wav")
	$AudioStreamPlayer.play()
	is_cooling = true

	



func _on_CooldownTimer_timeout():
	is_cooling = false


func _on_ActiveTimer_timeout():
	cycle_vision_mode()
