extends ColorRect

@export var curse_holded = "res://resource/curses/testcurse.tscn"

func _ready() -> void:
	var crs = load(curse_holded).instantiate()
	$TextureRect.texture = crs.icon_
	$VBoxContainer/Label.text = crs.name_
	$VBoxContainer/Label2.text = crs.downside
	$VBoxContainer/Label3.text = crs.upside
