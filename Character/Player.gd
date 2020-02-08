extends KinematicBody2D

# 継承すると保管が効かなくてだるいのでハードコート
const SPEED = 10
const MAX_SPEED = 200
const FRICTION = 0.1
# 移動速度係数 (変装時は遅くなる)
var velocity_multiplier = 1

var motion = Vector2()  # 引数なし = (0, 0)


func _physics_process(delta):
	update_movement()
	move_and_slide(motion * velocity_multiplier)
	if is_disguised:
		$Label.rect_rotation = -rotation_degrees
		$Label.text = str($Timer.time_left).pad_decimals(2)


	
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
	

# 変装、Disguise
const PLAYER_LAYER = 0b1
const DISGUISE_LAYER = 0b10000

# 3回まで変装できる。持続時間は5秒
export var disguises = 3
export var disguise_duration = 5
export var disguise_slowdown = 0.25
var is_disguised = false


func _input(event):
	if Input.is_action_just_pressed("toggle_disguise"):
		toggle_disguise()
	switch_light()

func toggle_disguise():
	if is_disguised:
		reveal()
	elif disguises > 0:
		disguise() 

func disguise():
	$Label.show()
	$Sprite.texture = load("res://Heist-Meisters-Assets/GFX/PNG/Tiles/tile_129.png")
	$LightOccluder2D.occluder = load("res://Character/BoxOccluderpolygon2d.tres")
	self.collision_layer = DISGUISE_LAYER
	disguises -= 1
	velocity_multiplier = disguise_slowdown
	is_disguised = true
	$Timer.start()
	# UI更新
	get_tree().call_group("DisguiseDisplay", "update_disguises", disguises)

func reveal():
	$Label.hide()
	$Timer.stop()
	$Sprite.texture = load("res://Heist-Meisters-Assets/GFX/PNG/Hitman 1/hitman1_stand.png")
	$LightOccluder2D.occluder = load("res://Character/PlayerOccluderpolygon2d.tres")
	velocity_multiplier = 1
	self.collision_layer = PLAYER_LAYER
	is_disguised = false
	

# Disguise 制限時間

func _ready():
	$Label.hide()
	$Timer.wait_time = disguise_duration
	$Timer.one_shot = true
	get_tree().call_group("DisguiseDisplay", "update_disguises", disguises)

func _on_Timer_timeout():
	reveal()


# BriefCase

func collect_briefcase():
	var loot = Node.new()
	loot.name = "briefcase"
	self.add_child(loot)
	get_tree().call_group("LootContainer", "collect_loot")
	
	
	
