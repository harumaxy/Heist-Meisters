extends KinematicBody2D

# 継承すると保管が効かなくてだるいのでハードコート
const SPEED = 10
const MAX_SPEED = 200
const FRICTION = 0.1

var motion = Vector2()  # 引数なし = (0, 0)


func _physics_process(delta):
	update_movement()
	move_and_slide(motion)		# 二重継承すると、親の親のメソッドが保管されなくて辛い
	switch_light()


	
func update_movement():
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("move_down") and not Input.is_action_pressed("move_up"):
		motion.y += SPEED
	elif Input.is_action_pressed("move_up") and not Input.is_action_pressed("move_down"):
		motion.y -= SPEED
	else:
		motion.y = lerp(motion.y, 0, FRICTION )		# lerp(from, to, step) : step は 0 ~ 1. 現在値から目的値まで、stepの割合分だけ変化
		
	if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		motion.x += SPEED
	elif Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		motion.x -= SPEED
	else:
		motion.x = lerp(motion.x, 0, FRICTION )
		
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	motion.y = clamp(motion.y, -MAX_SPEED, MAX_SPEED)
	
# Torch の代わりに、 Vision Modeを切り替えるGroup 関数呼び出し
func switch_light():
	if Input.is_action_just_pressed("toggle_vision_mode"):
		get_tree().call_group("Interface", "cycle_vision_mode")
		

