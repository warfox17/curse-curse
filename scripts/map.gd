extends Node3D

@export var id = "1"

@onready var world_ = $".."

@onready var player = get_node("../player" + id)
@onready var enemis = get_node("../enemies" + id)
@onready var projectiles = get_node("../projectiles" + id)

@onready var enemies = [preload("res://scene/enemy.tscn"), preload("res://scene/dasher.tscn")]
var known_spots = []
var pos = { "x" : 2, "y" : 2}

func _ready() -> void:
	_generate()

func _move(x,y):
	pos["x"] += x
	pos["y"] += y
	player.position = position
	player.position.x -= (x * 10)
	player.position.z -= (y * 5.5)
	for n in projectiles.get_children():
		n.queue_free()
	if known_spots.has(Vector2(pos["x"],pos["y"])):
		_generate()
	else:
		_generate_unkown()

func _check(body, dir):
	if pos["y"]+dir.y >= 0 && pos["y"]+dir.y <= 4:
		if pos["x"]+dir.x >= 0 && pos["x"]+dir.x <= 4:
			if enemis.get_child_count() <= 0:
				if body == player:
					_move(dir.x,dir.y)

func _on_door_1_body_entered(body: Node3D) -> void:
	_check(body,Vector2(0,-1))


func _on_door_2_body_entered(body: Node3D) -> void:
	_check(body,Vector2(0,1))


func _on_door_3_body_entered(body: Node3D) -> void:
	_check(body,Vector2(-1,0))


func _on_door_4_body_entered(body: Node3D) -> void:
	_check(body,Vector2(1,0))

func _generate_unkown():
	_generate()
	known_spots.append(Vector2(pos["x"],pos["y"]))
	match world_.dungeon_matrix[pos["y"]][pos["x"]]:
		0:
			for n in 4:
				var spr = 5
				var inst = enemies[randi_range(0,enemies.size() -1)].instantiate()
				inst.id = id
				if (n+1)%2 == 0:
					inst.position.z = spr
				else:
					inst.position.z = -spr
				if (n+1) > 2:
					inst.position.x = spr
				else:
					inst.position.x = -spr
				enemis.add_child(inst)
		3:
			$things/trap.visible = true
			$things/trap.process_mode = Node.PROCESS_MODE_PAUSABLE
	world_._render_map()

func _generate():
	for n in $things.get_children():
		n.process_mode = Node.PROCESS_MODE_DISABLED
		n.visible = false
	match world_.dungeon_matrix[pos["y"]][pos["x"]]:
		2:
			$things/shop.visible = true
			$things/shop.process_mode = Node.PROCESS_MODE_PAUSABLE
		4:
			$things/stairs.visible = true
			$things/stairs.process_mode = Node.PROCESS_MODE_PAUSABLE


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and $things/stairs.visible:
		GameManager._enter_stairs(body.player_id)



func _on_area_1_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and $things/trap.visible:
		GameManager._activate_trap(body.player_id)
		$things/trap.process_mode = Node.PROCESS_MODE_DISABLED
		$things/trap.visible = false


func _on_object_1_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and $things/shop.visible:
		if body._spend_money(100):
			body.damage += 2
			GameManager._notify("bought damage upgrade")


func _on_object_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and $things/shop.visible:
		if body._spend_money(100):
			body.health.max_health += 4
			body._on_health_healthchange(0)
			GameManager._notify("bought max health upgrade")


func _on_object_3_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and $things/shop.visible:
		if body._spend_money(100):
			body.dashcooldown_reach *= 0.9
			GameManager._notify("bought dash cooldown upgrade")
