extends ItemList

onready var box_texture = preload("res://Heist-Meisters-Assets/GFX/PNG/Tiles/tile_129.png")

func update_disguises(number):
	self.clear()
	for i in range(number):
		self.add_icon_item(box_texture, false)
