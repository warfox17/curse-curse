extends curse

var opponent

@onready var monster = preload("res://scene/enemy.tscn")
var enemis

func _on_equipped():
	super()
	enemis = get_node("../../../enemies" + id)
	opponent = get_node("../../../player" + op_id)
	opponent.enemy_killed.connect(_on_killed)

func _on_killed(en):
	if randi_range(0,7) == 1:
		var rand = Vector2(randf_range(-3.5,3.5),randf_range(-2.5,2.5))
		var twodiposplayer = Vector2(get_node("../..").position.x,get_node("../..").position.z)
		var enemisposition = Vector2(enemis.position.x,enemis.position.z)
		while (rand + enemisposition).distance_to(twodiposplayer) < 2.5:
			rand = Vector2(randf_range(-3.5,3.5),randf_range(-2.5,2.5))
		var ins = monster.instantiate()
		ins.id = id
		ins.position.x += rand.x
		ins.position.z += rand.y
		enemis.add_child(ins)
		$AudioStreamPlayer.play()
