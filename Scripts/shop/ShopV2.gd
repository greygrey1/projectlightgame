extends Node2D
@onready var dia = $RichTextLabel
@onready var textint = $diatimer
var timeBreak : bool = false 
var talking : bool = false
var items : PackedStringArray
var adding : PackedScene
@onready var mouse = $Area2D
var selitem
var checking : PackedStringArray
var notnull
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if Input.is_action_just_pressed("LMB"):	
		notnull = check_mouse_collisions()
		if notnull is Object:
			if not selitem == self:
				if selitem.global_position == Vector2(866, 442):
					var tween = self.create_tween()
					selitem.global_position = selitem.get_meta("pos")
					await tween.tween_property(selitem.get_children()[1], "global_position", selitem.get_meta("pos"), 0.4).finished
					checking.remove_at(checking.find(selitem.get_meta("name")))
				
				else:
					var tween = self.create_tween()
					selitem.global_position = Vector2(866, 442)
					await tween.tween_property(selitem.get_children()[1], "global_position", Vector2(866, 442), 0.4).finished
					checking.append(selitem.get_meta("name"))
			
	mouse.global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("2"):startup()
	if Input.is_action_just_pressed("1") and talking == false:
		talk("Well hello, good to meet you. What's your name?")
	elif Input.is_action_just_pressed("1") and talking == true:
		textint.wait_time = 0
		timeBreak = true
func talk(tex: String):
	dia.text = ""
	for i in tex.length():
		talking = true
		dia.text = tex.left(i)
		await typed(dia.text.right(1))
		if timeBreak == true:break
	timeBreak = false
	talking = false
	dia.text = tex
	

func typed(let: String):
	if let == ",":
		textint.wait_time = 0.1
	elif let == ".":
		textint.wait_time = 0.5
	else:
		textint.wait_time = 0.03
	$diatimer.start()
	await $diatimer.timeout

func startup():
	if true:
		if Phealth.invarray.has("silver seed"):
			print("ahh")
		else:
			additem("seed")
		if Phealth.invarray.has("walljump"):
			print("ahh")
		else:
			additem("walljump")
			print("walljump load")
func additem(s: String):
	if s == "seed":
		items.append("seed")
		adding = load("res://Scenes/Other/shopitems/seeditem.tscn")
		var a = adding.instantiate()
		self.add_child(a)
		a.global_position = Vector2(200, 240)
		a.mouse_entered.connect(self.flavor)
		a.set_meta("pos", a.global_position)
		a.get_children()[1].global_position = Vector2(200, 240)
		a.add_to_group("item")
		a.set_meta("name", "silver seed")
		a.set_meta("info", "A seed that you can shoot with A. (free)")
	if s == "walljump":
		items.append("walljump")
		adding = load("res://Scenes/Other/shopitems/seeditem.tscn")
		var a = adding.instantiate()
		self.add_child(a)
		a.global_position = Vector2(300, 240)
		a.mouse_entered.connect(self.flavor)
		a.set_meta("pos", a.global_position)
		a.get_children()[1].global_position = Vector2(300, 240)
		a.add_to_group("item")
		a.set_meta("name", "walljump")
		a.set_meta("info", "Allows you to jump off of purple walls. (free)")

func flavor():
	if mouse.get_overlapping_areas().size() > 0:
		for i in mouse.get_overlapping_areas().size():
			if mouse.get_overlapping_areas()[i].is_in_group("item"):
				dia.text = mouse.get_overlapping_areas()[i].get_meta("info")
	print(selitem)

func check_mouse_collisions():
	if mouse.get_overlapping_areas().size() > 0:
		selitem = self
		for i in mouse.get_overlapping_areas().size():
			if mouse.get_overlapping_areas()[i].is_in_group("item"):
				selitem = mouse.get_overlapping_areas()[i]
				dia.text = mouse.get_overlapping_areas()[i].get_meta("info")
	else:
		return("stop")
	return(selitem)


func _on_checkout_pressed():
	for i in checking.size():
		Phealth.invarray.append(checking[i])
		for q in self.get_child_count():
			if self.get_child(q).get_meta("name") == checking[i]:
				self.get_child(q).queue_free()
	
	
func close():
	for i in get_child_count():
		if self.get_child(i).is_in_group("item"):
			get_child(i).queue_free()
