extends enemy

var enemy_player

func _start():
	super()
	enemy_player = get_node("../../player" + op_id)

func _processing(delta):
	super(delta)
	velocity += Vector3(enemy_player.movingdir.x,0,-enemy_player.movingdir.y) * 4.5
