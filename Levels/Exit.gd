extends ColorRect

onready var Victory = load("res://Levels/Victory.tscn")

func _on_Area2D_body_entered(body):
	if body.has_node("briefcase"):
		get_tree().change_scene_to(Victory)
