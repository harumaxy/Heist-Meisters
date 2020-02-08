extends Area2D

const PLAYER_LAYER 	= 0b1
const TILEMAP_LAYER 	= 0b10
const NPC_LAYER 		= 0b100

var can_click = false

func _on_Door_body_entered(body: PhysicsBody2D):
	if body.collision_layer == PLAYER_LAYER:
		can_click = true
	else:
		open()


func _on_Door_body_exited(body: PhysicsBody2D):
	if body.collision_layer == PLAYER_LAYER:
		can_click = false


func _on_Door_input_event(viewport, event, shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_click:
		open()


func open():
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("Open")
