extends enemy


func _on_timer_timeout() -> void:
	momento_ = Vector2(velocity.x,velocity.z) * 1.1
