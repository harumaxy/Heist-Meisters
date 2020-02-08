extends Node2D

export var combination_length = 4
export var combination_group = "Unset"

var can_click = false
var combination



signal combination_gen

func _ready():
	$Light2D.enabled = false
	combination = CombinationGenerator.generate_combination(combination_length)
	set_popup_text("Password: " + PoolStringArray(combination).join(""))
	emit_signal("combination_gen", combination, combination_group)
	$Label.text = combination_group
	$Label.rect_rotation = -rotation_degrees
	
	
func set_popup_text(text: String):
	$CanvasLayer/ComputerPopup/NinePatchRect/CenterContainer/NinePatchRect/Label.text = text
	

func _on_Area2D_body_entered(body):
	can_click = true
	$Light2D.enabled = true

func _on_Area2D_body_exited(body):
	can_click = false
	$Light2D.enabled = false
	$CanvasLayer/ComputerPopup.hide()


func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_click:
		$CanvasLayer/ComputerPopup.popup_centered()


