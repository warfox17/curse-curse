extends ColorRect

@export var id = "1"

var slot = preload("res://scene/slot.tscn")

var picks
var player
var enemyplayer
var selection = 1

var perkpick = []

var buffer
var resulting_perks
var op_id

var active = false

func _ready() -> void:
	if id == "1":
		op_id = "2"
	elif id == "2":
		op_id = "1"
	enemyplayer = get_node("../../player"+op_id)

func _set_curses():
	player = get_node("../../player"+id)
	picks = 0
	var numbers = []
	perkpick = []
	for i in $HBoxContainer.get_children():
		i.queue_free()
	for n in GameManager.curses:
		if !enemyplayer.already_curses.has(n):
			perkpick.append(n)
	if perkpick.size() >= 3:
		picks = 3
	else:
		picks = perkpick.size()
	if perkpick.size() == 0:
		print("zero")
		active = false
		visible = false
		_got_curse()
		print(active)
		return
	for n in picks:
		var choice = randi_range(0, perkpick.size()-1)
		while numbers.has(choice):
			choice = randi_range(0, perkpick.size()-1)
		numbers.append(choice)
	resulting_perks = []
	for n in numbers:
		resulting_perks.append(perkpick[n])
	for n in picks:
		var ins = slot.instantiate()
		ins.curse_holded = resulting_perks[n]
		$HBoxContainer.add_child(ins)

func _process(_delta: float) -> void:
	if active:
		if Input.is_action_just_released("shoot"+id):
			enemyplayer._get_curse(resulting_perks[selection])
			visible = false
			active = false
			_got_curse()
		if (!Input.is_action_pressed("controller_left_left" + id) and !Input.is_action_pressed("controller_left_right" + id)) and buffer:
			selection += buffer
			buffer = null
		if Input.is_action_pressed("controller_left_left" + id):
			buffer = -1
		elif Input.is_action_pressed("controller_left_right" + id):
			buffer = 1
		if selection > picks -1:
			selection = 0
		elif selection < 0:
			selection = picks -1
		$"TextureRect".position.x = 150 + selection * 250
func _got_curse():
	if id == "1":
		await get_tree().create_timer(0.01).timeout
	if get_node("../end_level_choice" + op_id).visible == false:
		get_tree().paused = false
