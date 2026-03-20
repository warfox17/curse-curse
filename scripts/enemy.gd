extends CharacterBody3D
class_name enemy

@export var id = "1"
var op_id
@export var speed = 1.0
@onready var player = get_node("../../player" + id)
@onready var health = $health
var momento_ = Vector2(0,0)
@onready var hearth = preload("res://scene/projectiles/hearth.tscn")
@onready var projectiles = get_node("../../projectiles" + id)
@onready var rot = $rot
var curses

func _ready() -> void:
	_start()
func _start():
	if id == "1":
		op_id = "2"
		curses = GameManager.p1curses
	elif id == "2":
		op_id = "1"
		curses = GameManager.p2curses

func _process(delta: float) -> void:
	_processing(delta)
	move_and_slide()

func _processing(delta):
	var dir = -(Vector2(global_position.x,global_position.z) - Vector2(player.position.x,player.position.z)).normalized()
	velocity = Vector3(dir.x,0,dir.y) * speed
	if curses.has("res://resource/curses/commando.tscn") and position.z > 0:
		velocity *= 1.3
	velocity += _momento() * 40
	rot.rotation.y = -dir.normalized().angle()

func _die():
	player._get_money(randi_range(2,3))
	if randi_range(0,10) > 8:
		var instancehearth = hearth.instantiate()
		instancehearth.position = global_position
		projectiles.add_child(instancehearth)
	player._enemy_killed(self)
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.health._hurt(7)
		body.momento = -(Vector2(global_position.x,global_position.z) - Vector2(player.position.x,player.position.z)).normalized()

func _momento():
	if momento_ != Vector2.ZERO:
		momento_ = momento_ / 1.2
	return Vector3(momento_.x,0,momento_.y)
