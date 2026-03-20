extends Node3D

var shops = 1
var traps = 3

var seed

var first_player_escaping = null
var player_on_the_run = null

@onready var map = $Control/map

@onready var map1 = $map1
@onready var map2 = $map2

var dungeon_matrix = [
	[0,0,0,0,0],
	[0,0,0,0,0],
	[0,0,1,0,0],
	[0,0,0,0,0],
	[0,0,0,0,0]
	]

func _ready() -> void:
	seed = randi()
	seed(seed)
	_generate()
	_render_map()
	next_level()

func _generate():
	for n in shops:
		_gen_shop()
	for n in traps:
		_gen_trap()
	for n in 1:
		_gen_exit()

func _interacted_with_stairs(id):
	if first_player_escaping != null:
		if id != first_player_escaping:
			next_level()
			first_player_escaping = null
	else:
		if id == "1":
			player_on_the_run = "2"
		else:
			player_on_the_run = "1"
		$Timer.start()
		first_player_escaping = id
		if id == "1":
			GameManager._notify("zombina is ready to go")
			await get_tree().create_timer(1.0).timeout
			GameManager._notify("jhonny, chop chop bro!")
		else:
			GameManager._notify("jhonny is ready to go")
			await get_tree().create_timer(1.0).timeout
			GameManager._notify("zombina girl, move!")

func _gen_shop():
	var rdx = randi_range(0,4)
	var rdy = randi_range(0,4)
	var choice = dungeon_matrix[rdx][rdy]
	if choice == 0:
		dungeon_matrix[rdx][rdy] = 2
	else:
		_gen_shop()
func _gen_trap():
	var rdx = randi_range(0,4)
	var rdy = randi_range(0,4)
	var choice = dungeon_matrix[rdx][rdy]
	if choice == 0:
		dungeon_matrix[rdx][rdy] = 3
	else:
		_gen_trap()
func _gen_exit():
	var rdx = randi_range(0,4)
	var rdy = randi_range(0,4)
	var choice = dungeon_matrix[rdx][rdy]
	if choice == 0:
		dungeon_matrix[rdx][rdy] = 4
	else:
		_gen_exit()

func next_level():
	seed(randi())
	$Timer.stop()
	dungeon_matrix = [[0,0,0,0,0],[0,0,0,0,0],[0,0,1,0,0],[0,0,0,0,0],[0,0,0,0,0]]
	for n in map.get_child_count():
		for i in map.get_child(n).get_children():
			i.color = Color.BLACK
	_generate()
	map1.pos = { "x" : 2, "y" : 2}
	map2.pos = { "x" : 2, "y" : 2}
	map1.known_spots =[]
	map2.known_spots =[]
	$player1.position = Vector3.ZERO
	$player2.position = Vector3(0,0,17)
	map1._generate_unkown()
	map2._generate_unkown()
	$Control/end_level_choice1.visible = true
	$Control/end_level_choice1._set_curses()
	$Control/end_level_choice2.visible = true
	$Control/end_level_choice2._set_curses()
	for n in $enemies1.get_children():
		n.queue_free()
	for n in $enemies2.get_children():
		n.queue_free()
	get_tree().paused = true
	await get_tree().create_timer(0.4).timeout
	$Control/end_level_choice1.active = true
	$Control/end_level_choice2.active = true

func _render_map():
	var all_known_pos = map1.known_spots + map2.known_spots
	for n in map.get_child_count():
		for i in map.get_child(n).get_child_count():
			if all_known_pos.has(Vector2(n,i)):
				match dungeon_matrix[i][n]:
					1:
						map.get_child(n).get_child(i).color = Color.MEDIUM_ORCHID
					2:
						map.get_child(n).get_child(i).color = Color.GREEN
					3:
						map.get_child(n).get_child(i).color = Color.MEDIUM_VIOLET_RED
					4:
						map.get_child(n).get_child(i).color = Color.GOLD
					0:
						map.get_child(n).get_child(i).color = Color.ALICE_BLUE


func _on_timer_timeout() -> void:
	get_node("player" + player_on_the_run).health._hurt(1)
