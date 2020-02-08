extends "res://Levels/Door.gd"

var is_locked = true

func _ready():
	$Label.rect_rotation = -rotation_degrees

func _on_Door_input_event(viewport, event, shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_click:
		if not is_locked:
			open()
		else:
			$CanvasLayer/NumberPad.popup_centered()

func _on_Door_body_exited(body: PhysicsBody2D):
	if body.collision_layer == PLAYER_LAYER:
		can_click = false
		$CanvasLayer/NumberPad.hide()


# 独自signal : NumberPadに入力したパスコードが正解だったら開く
func _on_NumberPad_combination_correct():
	is_locked = false
	open()


func _on_Computer_combination_gen(numbers, combination_group):
	$CanvasLayer/NumberPad.set_combination(numbers)
	$Label.text = combination_group
	
