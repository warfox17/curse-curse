extends Node

class_name curse

var id = "1"

var op_id

@export var cursed = true

@export var icon_ : Texture2D

@export var name_ = ""

@export var downside = ""

@export var upside = ""

@onready var player = get_node("../..")

func _on_equipped():
	if id == "1":
		op_id = "2"
	elif id == "2":
		op_id = "1"
