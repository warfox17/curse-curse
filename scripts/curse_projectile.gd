extends CharacterBody3D

var id = "1"

@onready var area = $Area3D

var damage = 7

var playersided = true

var bounces = 0

var collision

var curses

func _ready() -> void:
	velocity = transform.basis * Vector3(1,0,0).normalized() * 0.3
	if id == "1":
		curses = GameManager.p1curses
	else:
		curses = GameManager.p2curses
	if curses.has("res://resource/curses/curse_of_ricochet.tscn"):
		bounces += 1

func _process(_delta: float) -> void:
	collision = move_and_collide(velocity)
	if collision:
		if bounces <= 0:
			queue_free()
		else:
			if curses.has("res://resource/curses/curse_of_ricochet.tscn"):
				playersided = false
				$MeshInstance3D2.visible = true
			velocity = velocity.bounce(collision.get_normal())
			bounces -= 1


func _on_area_3d_body_entered(body: Node3D) -> void:
	if playersided:
		if body.is_in_group("target"):
			body.health._hurt(damage)
			queue_free()
	else:
		if body.is_in_group("player"):
			body.health._hurt(7)
			queue_free()
