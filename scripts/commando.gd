extends curse


func _on_equipped():
	$TextureRect.position = Vector2(960.0 * (float(id) -1),540.0 * (float(id) -1))
	$TextureRect.visible = true
