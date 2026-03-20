extends Node
class_name health_comp

@export var max_health = 20
var health
signal healthchange(amm)

func _ready() -> void:
	health = max_health

func _hurt(dam : int):
	health -= dam
	if health <= 0:
		$".."._die()
	healthchange.emit(dam)

func _heal(amm : int):
	if health <= max_health:
		if health + amm <= max_health:
			health += amm
		else:
			health = max_health
	healthchange.emit(amm)
