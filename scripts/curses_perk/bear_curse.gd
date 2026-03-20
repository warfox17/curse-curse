extends curse

var enemis
var opponent
@onready var monster = preload("res://scene/explosion.tscn")

func _on_equipped():
	super()
	GameManager.activate.connect(_activated)
	enemis = get_node("../../../enemies" + id)
	opponent = get_node("../../../player" + op_id)

func _activated(id):
	if id == op_id:
		$AudioStreamPlayer.play()
		for n in 20:
			var rand = Vector2(randf_range(-9.5,9.5),randf_range(-6.5,6.5))
			var ins = monster.instantiate()
			ins.position.x += rand.x
			ins.position.z += rand.y
			enemis.add_child(ins)
			await get_tree().create_timer(0.5).timeout
