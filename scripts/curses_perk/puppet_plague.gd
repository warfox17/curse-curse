extends curse

var map

func _on_equipped():
	super()
	map = get_node("../../../map" + id)
	await get_tree().create_timer(0.01).timeout
	map.enemies.append(preload("res://scene/puppet.tscn"))
