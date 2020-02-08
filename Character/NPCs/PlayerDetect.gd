extends KinematicBody2D

const SPEED = 10
const MAX_SPEED = 200
const FRICTION = 0.1

const FOV_TOLERANCE = 20
const RED = Color(1.0, 0.25, 0.25)
const WHITE = Color(1, 1, 1)

const MAX_DETECTION_RANGE = 640

var Player : KinematicBody2D

func _ready():
	Player = get_node("/root").find_node("Player", true, false)
	
func _process(delta):
	if is_Player_in_FOV() and is_Player_in_LOS():
		$Torch.color = RED
		get_tree().call_group("SuspicionMeter", "player_seen")
	else:
		$Torch.color = WHITE
		
func is_Player_in_FOV():
	var npc_facing_derection = Vector2(1, 0).rotated(global_rotation)
	var direction_to_Player = (Player.position - global_position).normalized()
	
	# vecA.angle_to(vecB) : vecAからvecBの角度を返す (-PIE ~ PIE、 時計回りが正の方向)	
	# PlayerがFOVの範囲にいるかどうかを返す
	if abs(direction_to_Player.angle_to(npc_facing_derection)) < deg2rad(FOV_TOLERANCE):
		return true
	else:
		return false

func is_Player_in_LOS():
	
	# Player-NPC間に障害があるかの判定
	var space = get_world_2d().direct_space_state
	# obstacle = 障害
	var LOS_obstacle = space.intersect_ray( 
		global_position,
		Player.global_position, 
		[self], 
		collision_mask)
	# もしも何も衝突しなかったら戻る
	# Playerが"Disguise"レイヤーにいるときも反応しない
	if not LOS_obstacle:
		return false
		
	# 視野の距離に入っているかの判定
	var distance_to_player = Player.global_position.distance_to(self.global_position)
	var is_player_in_range = distance_to_player < MAX_DETECTION_RANGE
	if LOS_obstacle.collider == Player and is_player_in_range:
		return true
	else:
		return false
