extends curse


func _on_timer_timeout() -> void:
	$TextureRect.visible = true
	$TextureRect/AnimatedSprite2D.position = Vector2(960.0 * (float(id) -1) + randf_range(0.0,960.0),540.0 * (float(id) -1) + randf_range(0.0,540.0))
	match randi_range(0,1):
		0:
			$TextureRect/AnimatedSprite2D.play("baka")
		1:
			$TextureRect/AnimatedSprite2D.play("bike")
	$AudioStreamPlayer.stream = load("res://sounds/curses/kabuki" + str(randi_range(1,5)) + ".ogg")
	$AudioStreamPlayer.play()
	$Timer.wait_time = randf_range(4.0,7.0)
