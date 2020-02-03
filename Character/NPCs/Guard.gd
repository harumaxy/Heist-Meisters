extends "res://Character/NPCs/PlayerDetect.gd"

onready var navigation = get_tree().get_root().find_node("Navigation2D", true, false)
onready var destinations = navigation.get_node("Destinations")

var motion: Vector2
var possible_destinations: Array
var path: Array

export var minimum_arrival_distance = 5
export var walk_speed = 0.5

func _ready():
	randomize()
	possible_destinations = destinations.get_children()
	make_path()
	
	
func _physics_process(delta):
	navigate()
	
func navigate():
	var distance_to_destisnation = position.distance_to(path[0])
	if distance_to_destisnation > minimum_arrival_distance:
		move()
	else:
		update_path()


# path[0](次の移動先の通過点)の方向を向き、移動する
func move():
	look_at(path[0])
	motion = ((path[0] as Vector2) - position).normalized() * MAX_SPEED * walk_speed
	move_and_slide(motion)
	
	if is_on_wall():	# KinematicBody2Dがぶつかったら、新たなpathを作ることでハングアップを防ぐ
		make_path()
	
	
func update_path():
	if path.size() == 1:			# and 条件だと、タイマー起動中 かつ size=1 だと remove(0)してnull参照するので if を入れ子にする
		if $Timer.is_stopped():
			$Timer.start()
	else:
		path.remove(0)

# ランダムに移動先を1つ選択し、そこまでのPathを生成してグローバルpathにセット
func make_path():
	var new_destination = possible_destinations[randi() % possible_destinations.size() - 1] as Position2D
	path = navigation.get_simple_path(position, new_destination.position, false)  # パス生成。最適化をfalseにすると、引っ掛かりにくい経路を作る
	print(path)
	

func _on_Timer_timeout():
	make_path()
