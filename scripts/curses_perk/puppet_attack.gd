extends curse

var enemis
var opponent
@onready var monster = preload("res://scene/puppet.tscn")

func _on_equipped():
	super()
	GameManager.activate.connect(_activated)
	enemis = get_node("../../../enemies" + id)
	opponent = get_node("../../../player" + op_id)

func _activated(_id):
	if _id == op_id:
		for n in 3:
			var rand = Vector2(randf_range(-3.5,3.5),randf_range(-2.5,2.5))
			var twodiposplayer = Vector2(get_node("../..").position.x,get_node("../..").position.z)
			var enemisposition = Vector2(enemis.position.x,enemis.position.z)
			while (rand + enemisposition).distance_to(twodiposplayer) < 2.5:
				rand = Vector2(randf_range(-3.5,3.5),randf_range(-2.5,2.5))
			var ins = monster.instantiate()
			ins.position.x += rand.x
			ins.position.z += rand.y
			ins.id = id
			enemis.add_child(ins)
