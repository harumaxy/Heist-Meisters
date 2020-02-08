extends NinePatchRect

onready var loot_texture = preload("res://Heist-Meisters-Assets/GFX/Loot/suitcase.png")

func _ready():
	self.visible = false

func collect_loot():
	visible = true
	$VBoxContainer/LootList.add_icon_item(loot_texture, false)
