extends Node2D

var texts

func update_pointer_position(index: int):
	var pointer = $ObjectivePointer
	var marker = $ObjectiveMarkers.get_child(index) as Position2D
	$Tween.interpolate_property(
		pointer, "position", 
		pointer.position,marker.position,
		0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	$Tween.start()
	$AudioStreamPlayer.play()
	$TutorialGuide/Popup/GuideContainer/Label.text = texts[str(index)]
#	pointer.position = marker.positzion
	# 一回触った目的地エリアは、scene treeから取り除く
	remove_area()
	
func _ready():
	self.add_to_group("Interface")
	texts = load_json()
	update_pointer_position(0)
	$TutorialGuide/Popup.show()
	

func load_json():
	var file = File.new()
	file.open("res://Text/TutorialTexts.tres", File.READ)
	var content = file.get_as_text()
	file.close()
	return parse_json(content)
	

func remove_area():
	var areas = get_tree().root.find_node("ObjectiveAreas", true, false) as Node
	var children = areas.get_children()
	areas.remove_child(children[0])


	
func _on_Move_body_entered(body):
	update_pointer_position(1)


func _on_Door_body_entered(body):
	update_pointer_position(2)


func _on_Move2_body_entered(body):
	update_pointer_position(3)

func _on_Loot_body_entered(body):
	update_pointer_position(4)  
	

#var is_night_vision = false
#
#func cycle_vision_mode():
#	if is_night_vision:
#		DARK_mode()
#	else :
#		NIGHTVISION_mode()
#
#func DARK_mode():
#	is_night_vision = false
#	$TutorialGuide/Popup.show()
#
#func NIGHTVISION_mode():
#	is_night_vision = true
#	$TutorialGuide/Popup.hide()

