extends CharacterBody3D

@export var player_id = "1"
@export var damage = 7
var movingdir = Vector2.ZERO
var momento = Vector2(0,0)
var lookdir = 0
var meshdir = 0
@onready var rotational = $ratational
var cooldown = 0
var cooldown_reach = 0.7
var dashcooldown = 0
@export var dashcooldown_reach = 1.3
var bullet = preload("res://scene/projectiles/default_curse.tscn")
@onready var projectiles = get_node("../projectiles" + player_id)
@onready var lives_ui = get_node("../Control/lives_ui" + player_id)
@onready var health_ui = get_node("../Control/health_ui" + player_id)
@onready var stars_ui = get_node("../Control/money" + player_id)
@onready var choice = get_node("../Control/end_level_choice" + player_id)
@onready var marker = $ratational/Marker3D
@onready var health = $health
@onready var deathscreen = $"../Control/death_screen"
@onready var curse_holder = $curse_holder
@export var lives = 5
var already_curses = []
var money = 0
var is_cursedfing = false
var curses
var enemy_player
signal enemy_killed


func _ready() -> void:
	if player_id == "1":
		enemy_player = get_node("../player2")
	else:
		enemy_player = get_node("../player1")

func _direction():
	movingdir = Vector2(Input.get_axis("controller_left_left"+player_id,"controller_left_right"+player_id),-Input.get_axis("controller_left_up"+player_id,"controller_left_down"+player_id)).normalized()
	if Vector2(Input.get_axis("controller_right_left"+player_id,"controller_right_right"+player_id),-Input.get_axis("controller_right_up"+player_id,"controller_right_down"+player_id)) != Vector2.ZERO:
		lookdir = Vector2(Input.get_axis("controller_right_left"+player_id,"controller_right_right"+player_id),-Input.get_axis("controller_right_up"+player_id,"controller_right_down"+player_id)).normalized().angle()
	elif movingdir != Vector2.ZERO:
		lookdir = Vector2(Input.get_axis("controller_left_left"+player_id,"controller_left_right"+player_id),-Input.get_axis("controller_left_up"+player_id,"controller_left_down"+player_id)).normalized().angle()

func _momento():
	if momento != Vector2.ZERO:
		momento = momento / 1.2
	return Vector3(momento.x,0,momento.y)

func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot"+player_id):
		$AnimationTree.set("parameters/Blend2 2/blend_amount",1)
	else:
		$AnimationTree.set("parameters/Blend2 2/blend_amount",0)
	cooldown += delta
	if cooldown >= cooldown_reach:
		if Input.is_action_pressed("shoot"+player_id):
			cooldown = 0
			shoot()
	_direction()
	rotational.rotation.y = lerp_angle(rotational.rotation.y, lookdir, 0.4)
	velocity = Vector3(movingdir.x,0,-movingdir.y) * 6 / (1+ int(Input.is_action_pressed("shoot"+player_id)))
	if is_cursedfing and velocity != Vector3.ZERO:
		velocity += enemy_player.velocity * 0.15
	if velocity != Vector3.ZERO:
		$AnimationTree.set("parameters/Blend2/blend_amount",1)
	else:
		$AnimationTree.set("parameters/Blend2/blend_amount",0)
	dashcooldown += delta
	if dashcooldown >= dashcooldown_reach:
		if Input.is_action_pressed("dash"+player_id):
			dashcooldown = 0
			momento = Vector2(velocity.x, velocity.z) * 0.15
	velocity += _momento() * 4000 * delta
	move_and_slide()

func shoot():
	var instancebullet = bullet.instantiate()
	instancebullet.position = marker.global_position
	instancebullet.rotation = marker.global_rotation
	instancebullet.id = player_id
	instancebullet.damage = damage
	$AudioStreamPlayer.play()
	projectiles.add_child(instancebullet)

func _die():
	health.health = health.max_health
	lives -= 1
	lives_ui.value = lives
	if lives == 0:
		get_tree().paused = true
		await get_tree().create_timer(0.3).timeout
		$"../Control/death_screen".visible = true
		$"../Control/death_screen".process_mode = Node.PROCESS_MODE_ALWAYS
		if player_id == "1":
			$"../Control/death_screen/VBoxContainer/Label".text = "Johnny o-cult"
			$"../Control/death_screen/VBoxContainer/Label3".text = "Zombina"
	


func _on_health_healthchange(amm: Variant) -> void:
	health_ui.value = health.health
	health_ui.max_value = health.max_health
	health_ui.get_node("Label").text = str(health.health) + "/" + str(health.max_health)

func _get_money(ammount):
	money += ammount
	stars_ui.text = str(money)

func _get_curse(thing):
	already_curses.append(thing)
	var inst = load(thing).instantiate()
	inst.id = player_id
	curse_holder.add_child(inst)
	inst._on_equipped()
	GameManager._update_curses(player_id)
	if player_id == "1":
		GameManager.p1curses.append(thing)
	else:
		GameManager.p2curses.append(thing)
	
	if player_id == "1":
		curses = GameManager.p1curses
	else:
		curses = GameManager.p2curses
	
	if curses.has("res://resource/curses/cursed_finger.tscn"):
		is_cursedfing = true


func _enemy_killed(en):
	enemy_killed.emit(en)

func _spend_money(money_):
	if money >= money_:
		money -= money_
		stars_ui.text = str(money)
		return true
	else:
		GameManager._notify("not enough money")
		return false
