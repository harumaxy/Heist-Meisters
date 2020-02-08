extends TextureProgress

var suspicion: float = 0
const suspicion_step = 1  		# 1secごとに上昇する値
const suspicion_dropoff = 0.25 # 1secごとに減少する値



func player_seen():
	suspicion += suspicion_step
	# progress.value を更新
	self.value = suspicion
	if suspicion >= self.max_value:
		end_game()
	

func _process(delta):
	suspicion -= suspicion_dropoff
	suspicion = clamp(suspicion, 0, self.max_value)
	self.value = suspicion
	
func end_game():
	get_tree().change_scene("res://Levels/GameOver.tscn")
