extends Node

var curses = ["res://resource/curses/curse_of_necromancy.tscn",
"res://resource/curses/puppet_plague.tscn",
"res://resource/curses/curse_of_ricochet.tscn",
"res://resource/curses/anime_curse.tscn",
"res://resource/curses/puppet_attack.tscn",
"res://resource/curses/bear_curse.tscn",
"res://resource/curses/commando.tscn",
"res://resource/curses/cursed_finger.tscn"]

var p1curses = []
var p2curses = []

signal activate

func _enter_stairs(id):
	get_node("/root/world")._interacted_with_stairs(id)

func _activate_trap(id):
	activate.emit(id)

func _update_curses(id):
	if get_node("/root/world/Control/curses" +id).get_child_count() > 0:
		for n in get_node("/root/world/Control/curses" +id).get_children():
			n.queue_free()
	for n in get_node("/root/world/player" + id + "/curse_holder").get_children():
		var thinga = TextureRect.new()
		thinga.texture = n.icon_
		get_node("/root/world/Control/curses" +id).add_child(thinga)
	
func _notify(txt):
	var lab = load("res://scene/note.tscn").instantiate()
	lab.text = txt
	lab.position.y = -100
	add_child(lab)
	var twee = create_tween()
	twee.tween_property(lab,"position",Vector2(lab.position.x,209.0),0.9)
	await twee.finished
	lab.queue_free()
